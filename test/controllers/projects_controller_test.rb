require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
    @update = {
      id: 34,
      year: 2013,
      semester: 'MyString',
      project_start: '2013-11-08 23:10:35',
      project_end: '2013-11-08 23:10:35',
      comment: 'MyString',
      created_at: '2013-11-08 23:10:35',
      updated_at: '2013-11-08 23:10:35',
      max_clients: 1,
      max_green_clients: 1,
      max_white_clients: 1,
      max_yellow_clients: 1,
      use_max_clients: 0,
      project_type_id: 1
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: @update
    end

    assert_redirected_to projects_next_step_path
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: @update
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
  
    test "should render correct template and layout" do
    get :index
    assert_template layout: "layouts/application"
  end
end
