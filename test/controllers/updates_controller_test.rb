require 'test_helper'

class UpdatesControllerTest < ActionController::TestCase
  test "should render correct template and layout" do
    get :index
    assert_template layout: "layouts/application"
  end
end
