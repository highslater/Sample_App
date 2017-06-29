require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do

    mposts1 = @user.microposts.paginate(:page => 1, :per_page => 5)
    mposts2 = @user.microposts.paginate(:page => 2, :per_page => 5)

    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_select 'h3', text: "Microposts (6)"
    assert_match @user.microposts.count.to_s, response.body
    assert_match @user.microposts.count.to_s, "6"
    assert_select 'div.pagination'

    mposts1.each do |micropost|
      assert_match micropost.content, response.body
    end

    get user_path(@user, :page=> 2)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_select 'h3', text: "Microposts (6)"
    assert_match @user.microposts.count.to_s, response.body
    assert_match @user.microposts.count.to_s, "6"
    assert_select 'div.pagination'

    mposts2.each do |micropost|
      assert_match micropost.content, response.body

    end

  end

  test "logged in root display" do
    get root_path
    assert_template '/'
    assert_select 'title', full_title()
    assert_select 'h1', text: "Welcome to the Sample App"


    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)



    assert is_logged_in?

    get root_path
    assert_template '/'
    assert_select "title", full_title()
    assert_select 'h1', text: @user.name
    assert_select 'h3', text: "Micropost Feed"


  end

  ##mine

  test "presence of delete links" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
=begin
    @user.microposts.each do |m|
      p m.id
    end
=end

    assert is_logged_in?
    # ! BRITTLE !
    # these will probably break when a database reseed is run get ids from
    # @user.microposts.each do |m|
    #   p m.id
    # end
    get root_path(:page=> 1)
    assert_select 'a', text: 'delete', count: 5

    assert_select "a[href=?]", '/microposts/941832919', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/499495288', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/12348100', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/1033843180', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/177734013', text: 'delete', count: 1

    get user_path(@user, :page=> 1)
    assert_select 'a', text: 'delete', count: 5

    assert_select "a[href=?]", '/microposts/941832919', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/499495288', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/12348100', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/1033843180', text: 'delete', count: 1
    assert_select "a[href=?]", '/microposts/177734013', text: 'delete', count: 1

    get root_path(:page=> 2)
    assert_select 'a', text: 'delete', count: 1

    assert_select "a[href=?]", '/microposts/517500819', text: 'delete', count: 1

    get user_path(@user, :page=> 2)
    assert_select 'a', text: 'delete', count: 1

    assert_select "a[href=?]", '/microposts/517500819', text: 'delete', count: 1

  end

  ##/mine
end
