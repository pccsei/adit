require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @update = {
      id: 23,
      created_at: '2013-11-08 23:10:35',
      updated_at: '2013-11-08 23:10:35',
      school_id: 'tshoemaker',
      role: 1,
      email: 'tshoemaker@faculty.pcci.edu',
      phone: '17-1234-1',
      first_name: 'Troy',
      last_name: 'Shoemaker',
      box: 1,
      major: 'None',
      minor: 'None',
      classification: 'President',
      remember_token: 'MyString'
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @update
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: @update
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
  
  test "should render correct template and layout" do
    get :index
    assert_template layout: "layouts/application"
  end
end
