require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
setup do
    @ticket = tickets(:one)
    @update = {
      id: 1,
      sale_value: 1.5,
      page_size: 1.5,
      created_at: '2013-11-08 23:10:35',
      updated_at: '2013-11-08 23:10:35',
      payment_type: 'MyString',
      attachment: nil,
      attachment_name: 'MyString',
      project_id: 1,
      client_id: 1,
      user_id: 1,
      priority_id: 1
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post :create, ticket: @update
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should show ticket" do
    get :show, id: @ticket
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ticket
    assert_response :success
  end

  test "should update ticket" do
    patch :update, id: @ticket, ticket: @update
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete :destroy, id: @ticket
    end

    assert_redirected_to tickets_url
  end
  
    test "should render correct template and layout" do
    get :index
    assert_template layout: "layouts/application"
  end
end
