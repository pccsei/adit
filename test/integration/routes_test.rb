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
    assert_generates "/users/input_students_parse", :controller => "users", :action => "input_students_parse"
    assert_generates "/users/1", {:controller => "users", :action => "destroy", :id => "1"}
    assert_generates "/users/change_student_status", :controller => "users", :action => "change_student_status"
    assert_generates "/users/show_section", :controller => "users", :action => "show_section"
  end
  test "test client routes" do
    assert_generates "", :controller => "clients", :action => "index"
    assert_generates "/clients/1", {:controller => "clients", :action => "show", :id => "1"}
    assert_generates "/clients/new", :controller => "clients", :action => "new"
    assert_generates "/clients/1/edit", {:controller => "clients", :action => "edit", :id => "1"}
    assert_generates "/clients", :controller => "clients", :action => "create"
    assert_generates "/clients/1", {:controller => "clients", :action => "update", :id => "1"}
    assert_generates "/clients/1", {:controller => "clients", :action => "destroy", :id => "1"}
  end
  test "test project routes" do
    assert_generates "/projects", :controller => "projects", :action => "index"
    assert_generates "/projects/1", {:controller => "projects", :action => "show", :id => "1"}
    assert_generates "/projects/new", :controller => "projects", :action => "new"
    assert_generates "/projects/1/edit", {:controller => "projects", :action => "edit", :id => "1"}
    assert_generates "/projects", :controller => "projects", :action => "create"
    assert_generates "/projects/1", {:controller => "projects", :action => "update", :id => "1"}
    assert_generates "/projects/1", {:controller => "projects", :action => "destroy", :id => "1"}
  end
  test "test ticket routes" do
    assert_generates "/tickets", :controller => "tickets", :action => "index"
    assert_generates "/tickets/1", {:controller => "tickets", :action => "show", :id => "1"}
    assert_generates "/tickets/new", :controller => "tickets", :action => "new"
    assert_generates "/tickets", :controller => "tickets", :action => "create"
    assert_generates "/tickets/1", {:controller => "tickets", :action => "update", :id => "1"}
    assert_generates "/tickets/1", {:controller => "tickets", :action => "destroy", :id => "1"}
  end
  test "test receipts routes" do
    assert_generates "/receipts/1", {:controller => "receipts", :action => "show", :id => "1"}
    assert_generates "/receipts/new", :controller => "receipts", :action => "new"
    assert_generates "/receipts/1/edit", {:controller => "receipts", :action => "edit", :id => "1"}
    assert_generates "/receipts", :controller => "receipts", :action => "create"
    assert_generates "/receipts/1", {:controller => "receipts", :action => "update", :id => "1"}
    assert_generates "/receipts/1", {:controller => "receipts", :action => "destroy", :id => "1"}
  end
  test "test updates routes" do
    assert_generates "/updates", :controller => "updates", :action =>"index"
    assert_generates "/updates/1", {:controller => "updates", :action => "show", :id => "1"}
    assert_generates "/updates/new", :controller => "updates", :action => "new"
    assert_generates "/updates/1/edit", {:controller => "updates", :action => "edit", :id => "1"}
    assert_generates "/updates", :controller => "updates", :action => "create"
    assert_generates "/updates/1", {:controller => "updates", :action => "update", :id => "1"}
    assert_generates "/updates/1", {:controller => "updates", :action => "destroy", :id => "1"}
  end
end
