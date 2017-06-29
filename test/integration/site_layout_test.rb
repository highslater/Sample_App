require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end


  # Test Links

  test "layout links" do

    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1

    get help_path
    assert_template 'static_pages/help'
    assert_select "title", full_title("Help")
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1

    get about_path
    assert_template 'static_pages/about'
    assert_select "title", full_title("About")
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1


    get contact_path
    assert_template 'static_pages/contact'
    assert_select "title", full_title("Contact")
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1

    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1

    get login_path
    assert_template 'sessions/new'
    assert_select "title", full_title("Log in")
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", login_path, count: 1

    log_in_as(@user, remember_me: '0')
    follow_redirect!
    assert_template 'users/show'
    assert_select "title", full_title(@user.name)
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path, count: 1
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", contact_path, count: 1
    assert_select "a[href=?]", users_path, count: 1
    # assert_select dropdown menu "Account"
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", edit_user_path, count: 1
    assert_select "a[href=?]", user_path, count: 11


  end

  # /Test Links

end


=begin

assert_select "div" 
    <div>foobar</div>
assert_select "div", "foobar"   
    <div>foobar</div>
assert_select "div.nav" 
    <div class="nav">foobar</div>
assert_select "div#profile" 
    <div id="profile">foobar</div>
assert_select "div[name=yo]"    
    <div name="yo">hey</div>
assert_select "a[href=?]", ’/’, count: 1    
    <a href="/">foo</a>
assert_select "a[href=?]", ’/’, text: "foo" 
    <a href="/">foo</a>


assert( test, [msg] )
       Ensures that test is true.

assert_not( test, [msg] )
       Ensures that test is false.

assert_equal( expected, actual, [msg] )
       Ensures that expected == actual is true.

assert_not_equal( expected, actual, [msg] )
       Ensures that expected != actual is true.

assert_same( expected, actual, [msg] )
       Ensures that expected.equal?(actual) is true.

assert_not_same( expected, actual, [msg] )
       Ensures that expected.equal?(actual) is false.

assert_nil( obj, [msg] )
       Ensures that obj.nil? is true.

assert_not_nil( obj, [msg] )
       Ensures that obj.nil? is false.

assert_empty( obj, [msg] )
       Ensures that obj is empty?.

assert_not_empty( obj, [msg] )
       Ensures that obj is not empty?.

assert_match( regexp, string, [msg] )
       Ensures that a string matches the regular expression.

assert_no_match( regexp, string, [msg] )
       Ensures that a string doesn't match the regular expression.

assert_includes( collection, obj, [msg] )
       Ensures that obj is in collection.

assert_not_includes( collection, obj, [msg] )
       Ensures that obj is not in collection.

assert_in_delta( expected, actual, [delta], [msg] )
       Ensures that the numbers expected and actual are within delta of each other.

assert_not_in_delta( expected, actual, [delta], [msg] )
       Ensures that the numbers expected and actual are not within delta of each other.

assert_throws( symbol, [msg] )
       { block }  Ensures that the given block throws the symbol.

assert_raises( exception1, exception2, ... )
       { block }  Ensures that the given block raises one of the given exceptions.

assert_instance_of( class, obj, [msg] )
       Ensures that obj is an instance of class.

assert_not_instance_of( class, obj, [msg] )
       Ensures that obj is not an instance of class.

assert_kind_of( class, obj, [msg] 
     ) Ensures that obj is an instance of class or is descending from it.

assert_not_kind_of( class, obj, [msg] )
       Ensures that obj is not an instance of class and is not descending from it.

assert_respond_to( obj, symbol, [msg] )
       Ensures that obj responds to symbol.

assert_not_respond_to( obj, symbol, [msg] )
       Ensures that obj does not respond to symbol.

assert_operator( obj1, operator, [obj2], [msg] )
       Ensures that obj1.operator(obj2) is true.

assert_not_operator( obj1, operator, [obj2], [msg] )
       Ensures that obj1.operator(obj2) is false.

assert_predicate ( obj, predicate, [msg] )
       Ensures that obj.predicate is true, e.g. assert_predicate str, :empty?

assert_not_predicate ( obj, predicate, [msg] )
       Ensures that obj.predicate is false, e.g. assert_not_predicate str, :empty?

flunk( [msg] )
       Ensures failure. This is useful to explicitly mark a test that isn't finished yet.



=end
