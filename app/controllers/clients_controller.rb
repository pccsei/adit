class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :must_have_project

  # GET /clients
  # GET /clients.json
  def index
     
    #@clients = Client.house
    
    @clients = Client.for_selected_project(get_selected_project.id)   
    
    @projects = Project.all

  end
  
  def approve
    @pending_clients = Client.pending
    @edited_pending_clients = Client.edited_pending
    @unapproved_clients = Client.unapproved
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])
  end

  def assign
    if (params[:tid])
      @ticket = Ticket.find(params[:tid])    
    else
      @ticket = Ticket.select("id, client_id").where(client_id: params[:id], project_id: get_selected_project.id).first
    end      
    @client = Client.find(params[:cid])
  end
  


  def approve_client
    status = params['commit']
    array_of_pending_clients = params['clients']

    if array_of_pending_clients.present?
      if status == "Approve"
        Client.approve_clients(array_of_pending_clients)
      else 
        Client.unapprove_clients(array_of_pending_clients)
      end
    end

    redirect_to clients_approve_url
  end

  def approve_client_edit
    status = 2 if params['commit'] == "Approve" 
    status = 1 if params['commit'] == "Disapprove" 
    status = 3 if params['commit'] == "Approve All" 

    if status != 3
      array_of_edited_pending_clients = params['clients']
    else
      array_of_edited_pending_clients = Client.where(status_id: 5).ids
    end
    if !array_of_edited_pending_clients.nil?
      Client.approve_edited_clients(status, array_of_edited_pending_clients)   
    end
    
    redirect_to clients_approve_url
  end


  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
    if current_user.role != 3
      edited_client = @client
    end
  end

  # POST /clients
  # POST /clients.json
  def create
    
    @client = Client.new(client_params)
    @client.status_id = (Status.find_by(status_type: 'Pending')).id
    @client.submitter = current_user.first_name + " " + current_user.last_name
    
    # This line should eventually place the clients on the pending clients list instead of straight into the db
    # @client.status_id = Status.where("status_type = ?", "Pending").pluck(:id) 

    respond_to do |format|
      if @client.save
        if current_user.role == 3
          user = nil
        else
          user = current_user.id
        end
        Ticket.create(:user_id => user, :client_id => @client.id, 
                      :project_id => get_current_project.id, :priority_id => Priority.where("name = ?", "low").first.id)
        format.html { redirect_to clients_submit_path, notice: 'Client was successfully submitted.' }
        format.json { render action: 'show', status: :created, location: @client }
      else
        format.html { render action: 'new' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    if current_user.role != 3
      edited_client = Client.new
      edited_client = Client.find(@client).clone
      edited_client.assign_attributes(client_params)
      # render text: client_params
      Client.make_pending_edited_client(edited_client, @client, client_params) 
      redirect_to "/receipts/my_receipts/#{current_user.id}", notice: 'Your change has been submitted.'     
    else
      respond_to do |format|
        if @client.update(client_params)
          format.html { redirect_to @client, notice: 'Client was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end
  
  # For submitting a new client from the student
  def submit
    @client = Client.new
    @pending_clients = Client.pending    
    @unapproved_clients = Client.unapproved
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:id, :business_name, :address, :email, :telephone, :comment, :created_at, 
                                     :updataed_at, :website, :zipcode, :contact_fname, :contact_lname, :contact_title, 
                                     :city, :state, :status_id)
    end
end
