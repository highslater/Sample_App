require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # Test Controller Actions

  test "should get home" do
    get root_path
    assert_response :success
    assert_equal "home", @controller.action_name
    assert_select "title", full_title,
      "\n* Title should contain just the base title *\n"
    assert_select "h1", "Welcome to the Sample App",
      "\nThis should say Welcome to the Sample App\n"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_equal "help", @controller.action_name
    assert_select "title", full_title("Help"),
      "\n* Title should contain the word Help *\n"
    assert_select "h1", "Help", "\nThis should say Help\n"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_equal "about", @controller.action_name
    assert_select "title", full_title("About"),
      "\n* Title should contain the word About *\n"
    assert_select "h1", "About", "\nThis should say About\n"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_equal "contact", @controller.action_name
    assert_select "title", full_title("Contact"),
      "\n* Title should contain the word Contact *\n"
    assert_select "h1", "Contact", "\nThis should say Contact\n"
  end

  # /Test Controller Actions


  # Test Routing

  test "should route to home" do
    assert_generates "/", controller: "static_pages", action: "home"
    assert_recognizes({controller: 'static_pages', action: 'home'}, '/')
    assert_routing '/', controller: 'static_pages', action: 'home'
  end

  test "should route to help" do
    assert_generates "/help", controller: "static_pages", action: "help"
    assert_recognizes({controller: 'static_pages', action: 'help'}, '/help')
    assert_routing '/help', controller: 'static_pages', action: 'help'
  end

  test "should route to about" do
    assert_generates "/about", controller: "static_pages", action: "about"
    assert_recognizes({controller: 'static_pages', action: 'about'}, '/about')
    assert_routing '/about', controller: 'static_pages', action: 'about'
  end

  test "should route to contact" do
    assert_generates "/contact", controller: "static_pages", action: "contact"
    assert_recognizes({controller: 'static_pages', action: 'contact'}, '/contact')
    assert_routing '/contact', controller: 'static_pages', action: 'contact'
  end

  # / Test Routing


end


=begin


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
