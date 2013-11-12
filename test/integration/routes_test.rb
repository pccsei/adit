require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "test user routes" do
    assert_generates "/users", :controller => "users", :action => "index"
    assert_generates "/users/1", {:controller => "users", :action => "show", :id => "1"}
    assert_generates "/users/teacher", :controller => "users", :action => "teacher"
    assert_generates "/users/student_manager", :controller => "users", :action => "student_manager"
    assert_generates "/users/student_rep", :controller => "users", :action => "student_rep"
    assert_generates "/users/new", :controller => "users", :action => "new"
    assert_generates "/users/1/edit", {:controller => "users", :action => "edit", :id => "1"}
    assert_generates "/users", :controller => "users", :action => "create"
    assert_generates "/users/1", {:controller => "users", :action => "update", :id => "1"}
  end
  test "test client routs" do
    assert_generates "/clients", :controller => "clients", :action => "index"
    assert_generates "/clients/1", {:controller => "clients", :action => "show", :id => "1"}
    assert_generates "/clients/new", :controller => "clients", :action => "new"
    assert_generates "/clients/1/edit", {:controller => "clients", :action => "edit", :id => "1"}
    assert_generates "/clients", :controller => "clients", :action => "create"
    assert_generates "/clients/1", {:controller => "clients", :action => "update", :id => "1"}
  end
end
