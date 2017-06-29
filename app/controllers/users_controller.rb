class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :set_user,   only: [:show, :destroy]
  before_action :set_users,   only: [:index]
  before_action :set_microposts,   only: [:show]
  before_action :admin_user,     only: :destroy

  def index
  end

  def edit
  end

  def show
  end

  def new
    @user = User.new
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?

  end

  def set_users
    # @users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(:page=> params[:page], :per_page => 5)
  end

  def set_microposts
    @microposts = @user.microposts.paginate(:page=> params[:page], :per_page => 5)
  end



  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end


end
