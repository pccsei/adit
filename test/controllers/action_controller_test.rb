require 'test_helper'

class ActionsControllerTest < ActionController::TestCase
  setup do
    @action = actions(:one)
    @update = {
      points_earned: 1,
      user_action_time: '2013-11-08 23:36:28'
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create action" do
    assert_difference('Action.count') do
      post :create, action: @update
    end

    assert_redirected_to action_path(assigns(:action))
  end

  test "should show action" do
    get :show, id: @action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @action
    assert_response :success
  end

  test "should update action" do
    patch :update, id: @action, action: @update
    assert_redirected_to action_path(assigns(:action))
  end

  test "should destroy action" do
    assert_difference('Action.count', -1) do
      delete :destroy, id: @action
    end

    assert_redirected_to actions_path
  end
end
