require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
    @update = {
      id: 3,
      business_name: 'PCC',
      address: '250 Brent Lane',
      telephone: '111-111-1111',
      comment: "None",
      created_at: '2013-11-08 23:10:35',
      updated_at: '2013-11-08 23:10:35',
      zipcode: 1,
      contact_fname: 'Troy', 
      contact_lname: 'Shoemaker',
      contact_title: 'Dr.',
      city: 'Pensacola',
      state: 'FL',
      status_id: 1
    }
  end

  test "should get index" do
    get :root
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, client: @update
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    patch :update, id: @client, client: @update
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
  
  test "should render correct template and layout" do
    get :index
    assert_template layout: "layouts/application"
  end
end
