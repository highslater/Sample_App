class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
    presence: true,
    length: { maximum: 255 },
    uniqueness: { case_sensitive: false },
    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :microposts, dependent: :destroy

  has_many :active_relationships,
    class_name:  "Relationship",
    foreign_key: "follower_id",
    dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships,
    class_name:  "Relationship",
    foreign_key: "followed_id",
    dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end


  private

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end

=begin

  validates(*attributes)

------------------------------------------------------------------------------

This method is a shortcut to all default validators and any custom validator
classes ending in 'Validator'. Note that Rails default validators can be
overridden inside specific classes by creating custom validator classes in
their place such as PresenceValidator.

Examples of using the default rails validators:

  validates :terms, acceptance: true
  validates :password, confirmation: true
  validates :username, exclusion: { in: %w(admin superuser) }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :age, inclusion: { in: 0..9 }
  validates :first_name, length: { maximum: 30 }
  validates :age, numericality: true
  validates :username, presence: true
  validates :username, uniqueness: true

The power of the validates method comes when using custom validators and
default validators in one call for a given attribnew    def validate_each(record, attribute, value)
      record.errors.add attribute, (options[:message] || "is not an email") unless
        value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
  end

  class Person
    include ActiveModel::Validations
    attr_accessor :name, :email

    validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
    validates :email, presence: true, email: true
  end

Validator classes may also exist within the class being validated allowing
custom modules of validators to be included as needed.

  class Film
    include ActiveModel::Validations

    class TitleValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add attribute, "must start with 'the'" unless value =~ /\Athe/i
      end
    end

    validates :name, title: true
  end

Additionally validator classes may be in another namespace and still used
within any class.

  validates :name, :'film/title' => true

The validators hash can also handle regular expressions, ranges, arrays and
strings in shortcut form.

  validates :email, format: /@/
  validates :gender, inclusion: %w(male female)
  validates :password, length: 6..20

When using shortcut form, ranges and arrays are passed to your validator's
initializer as options[:in] while other types including regular expressions
and strings are passed as options[:with].

There is also a list of options that could be used along with validators:

* :on - Specifies the contexts where this validation is active. Runs in all
  validation contexts by default nil. You can pass a symbol or an array of
  symbols. (e.g. on: :create or on: :custom_validation_context or on:
  [:create, :custom_validation_context])
* :if - Specifies a method, proc or string to call to determine if the
  validation should occur (e.g. if: :allow_validation, or if: Proc.new {
  |user| user.signup_step > 2 }). The method, proc or string should return or
  evaluate to a true or false value.
* :unless - Specifies a method, proc or string to call to determine if the
  validation should not occur (e.g. unless: :skip_validation, or unless:
  Proc.new { |user| user.signup_step <= 2 }). The method, proc or string
  should return or evaluate to a true or false value.
* :allow_nil - Skip validation if the attribute is nil.
* :allow_blank - Skip validation if the attribute is blank.
* :strict - If the :strict option is set to true will raise
  ActiveModel::StrictValidationFailed instead of adding the error. :strict
  option can also be set to any other exception.

Example:

  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :token, uniqueness: true, strict: TokenGenerationException

Finally, the options :if, :unless, :on, :allow_blank, :allow_nil, :strict and
:message can be given to one specific validator, as a hash:

  validates :password, presence: { if: :password_required?, message: 'is forgotten.' }, confirmation: true




.has_secure_password

(from gem activemodel-5.1.1)
Implementation from ClassMethods
------------------------------------------------------------------------------
  has_secure_password(options = {})

------------------------------------------------------------------------------

Adds methods to set and authenticate against a BCrypt password. This mechanism
requires you to have a password_digest attribute.

The following validations are added automatically:
* Password must be present on creation
* Password length should be less than or equal to 72 characters
* Confirmation of password (using a password_confirmation attribute)

If password confirmation validation is not needed, simply leave out the value
for password_confirmation (i.e. don't provide a form field for it).
When this attribute has a nil value, the validation will not be
triggered.

For further customizability, it is possible to suppress the default
validations by passing validations: false as an argument.

Add bcrypt (~> 3.1.7) to Gemfile to use #has_secure_password:

  gem 'bcrypt', '~> 3.1.7'

Example using Active Record (which automatically includes
ActiveModel::SecurePassword):

  # Schema: User(name:string, password_digest:string)
  class User < ActiveRecord::Base
    has_secure_password
  end

  user = User.new(name: 'david', password: '', password_confirmation: 'nomatch')
  user.save                                                       # => false, password required
  user.password = 'mUc3m00RsqyRe'
  user.save                                                       # => false, confirmation doesn't match
  user.password_confirmation = 'mUc3m00RsqyRe'
  user.save                                                       # => true
  user.authenticate('notright')                                   # => false
  user.authenticate('mUc3m00RsqyRe')                              # => user
  User.find_by(name: 'david').try(:authenticate, 'notright')      # => false
  User.find_by(name: 'david').try(:authenticate, 'mUc3m00RsqyRe') # => user

=end
