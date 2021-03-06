class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers, only: [:index, :approve, :show_assign_for, :approve_client, :approve_client_edit, :destroy]
  
  # GET /clients
  # GET /clients.json
  def index   
    @projects = Project.all
    @tickets  = Client.tickets_for_selected_project(get_selected_project.id) #Ticket.where(project_id: get_selected_project.id)
  end
  
  def approve
    @pending_clients = Client.pending
    @edited_pending_clients = Client.edited_pending
    @unapproved_clients = Client.unapproved
  end
  
  # GET /clients/1
  # GET /clients/1.json
  def show

    @client   = Client.find(params[:id])
    
    # Save this value if user came from the receipts show page
    @receipt_id = params[:receipt_id]
      
    # Save the page url of the page where user came from 
    if params[:page]
      session[:return_to] = params[:page]
    end
     
    # Get the release comments made during the current project
    if (ticket = Ticket.find_by(project_id: get_current_project.id, client_id: @client.id))
       @comments = ticket.comments.pluck(:body)
    end

    # Get just the years where sales were made but not actual sale info exists
    @sales_years = Receipt.early_sale_years(@client)
    
    # Get the sales information about this specific client from the years after Adit was put into use
    @sales_info  = Receipt.sales_for_client_up_to_project(@client, get_selected_project)
  end
  
  def show_assign_for
    if (params[:tid])
      @ticket = Ticket.find(params[:tid])    
    else
      @ticket = Ticket.select('id, client_id').where(client_id: params[:id], project_id: get_selected_project.id).first
    end      
    @client = Client.find(@ticket.client_id)
    @sections = get_array_of_all_sections(get_current_project)
  end
  
  def assign
    #t = Ticket.where(user_id: params[:studentID], project_id: get_current_project.id) #ind(params[:studentID]);
    t = Ticket.find(params[:tid])    
    t.user_id =  User.where(school_id: params[:studentID]).first.id
    t.save    
    # Create a ticket for the student if he does not already have one.
    receipt = Receipt.where('ticket_id = ? AND user_id = ?', t.id, params[:studentID]).first
    r = Receipt.find_or_create_by(ticket_id: t.id, user_id: User.where(school_id: params[:studentID]).first.id)
    
    version_cleanup(current_user.id, "Receipt")
    version_cleanup(current_user.id, "Ticket")
    
    @message = User.where(school_id: params[:studentID]).first.to_s + 'is now assigned to ' + t.client.business_name.to_s
    # have the undo use the receipt id
    undo_link = view_context.link_to("Undo", revert_assign_version_path(t.versions.where(whodunnit: current_user.id).last), :method => :post)
    redirect_to clients_url, :notice => User.find_by_school_id(params[:studentID]).first_name.to_s + ' is now assigned to ' + t.client.business_name + ".  #{undo_link}"  
  end
  
  def pending_clients_excel
    @pending_clients = Client.pending
  end

  def edited_clients_excel
    @edited_pending_clients = Client.edited_pending
  end

  # Process the button choice on the approve client's page
  def approve_client
    status = params['commit']
    
    # This should probably be refactored to send the client ids from the front
    #    just in case delays happen and a client gets accidentally approved
    if status == 'Approve All'
       array_of_pending_clients = Client.pending.ids
    else
       array_of_pending_clients = params['clients']
    end
    
    if array_of_pending_clients.present?
      if (status == 'Approve') || (status == 'Approve All')
        message = Client.approve_clients(array_of_pending_clients)
      else 
        message = Client.unapprove_clients(array_of_pending_clients)
      end
    else
      message = "No clients were selected."
    end
    
    redirect_to clients_approve_url, flash: { notice: message }
  end
  
  # checks to see if the student is allowed to have more clients
  def more_allowed
    student = User.find_by_school_id(params[:school_id])
    render :text => Ticket.more_clients_allowed(student, get_selected_project, TEACHER, params[:priority])
  end
  
  # This only deals with the edited clients on the approve page, not the pending clients.
  def approve_client_edit
    status = 2 if params['commit'] == 'Approve'
    status = 1 if params['commit'] == 'Disapprove'
    status = 3 if params['commit'] == 'Approve All'
    if status != 3
      array_of_edited_pending_clients = params['clients']
    else
      array_of_edited_pending_clients = Client.edited_pending.ids
    end
    if !array_of_edited_pending_clients.nil?
      message = Client.approve_edited_clients(status, array_of_edited_pending_clients)
    else
      message = "No clients selected."
    end
    redirect_to clients_approve_url, flash: { notice: message }
  end
  
  # GET /clients/new
  def new
    @all_clients = Client.pluck(:business_name)
    @client = Client.new
  end
  
  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
    if ((current_user.role < TEACHER) && (current_user.id != @client.submitter) && ((current_user.tickets.find_by client_id: @client.id).present?) == false)
      redirect_to tickets_path, :notice => "You are not permitted to edit someone else's client. Welcome to your home page!"
    elsif params[:page]
        session[:return_from_edit] = params[:page]
    end
  end
  
  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    @client.status_id = (Status.find_by(status_type: 'Pending')).id
    @client.submitter = current_user.id
    # This line should eventually place the clients on the pending clients list instead of straight into the db
    # @client.status_id = Status.where("status_type = ?", "Pending").pluck(:id) 
       if current_user.role == TEACHER
          user = nil
        else
          user = current_user.id
        end
        if @client.save
        Ticket.create(:user_id => user, :client_id => @client.id, 
                      :project_id => get_current_project.id, :priority_id => Priority.where('name = ?', 'low').first.id)
        flash[:success] = 'Your client has been submitted for approval.'
        if current_user.role == TEACHER
          redirect_to clients_approve_path
        else
          redirect_to clients_submit_path
        end
      else
        render action: 'new', notice: "There was an error validating your client. Please enable Javascript or contact your teacher."
      end
  end
  
  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    
    if get_current_project
       ticket = @client.tickets.find_by(project_id: get_current_project.id)
    end
    status = @client.status.status_type 
    if current_user.role != TEACHER
      edited_client = Client.new
      edited_client = Client.find(@client).clone
      edited_client.assign_attributes(client_params)

      Client.make_pending_edited_client(edited_client, @client, client_params, current_user.id)
      redirect_to session[:return_from_edit], notice: 'Your change has been submitted. Your client will be updated once the teacher approves your changes.'     
    elsif @client.update(client_params)
       if status == "Unapproved"
          if ticket.present?
            ticket.user_id = nil
            ticket.save
          end
       elsif status == "Approved"
         if !ticket && get_current_project
           Ticket.create(project_id: get_current_project.id, client_id: @client.id, priority_id: Priority.find_by(name: 'low').id)
         end
       elsif status == "In House"
         if !ticket && get_current_project
            Ticket.create(project_id: get_current_project.id, client_id: @client.id, priority_id: Priority.find_by(name: 'low').id)
         end
       end
       redirect_to session[:return_from_edit], notice: 'Client was successfully updated.'
    else
       render action: 'edit' 
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
    @all_clients = Client.pluck(:business_name)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:id, :business_name, :address, :telephone, :comment, :created_at, :email, 
                                     :updated_at, :zipcode, :contact_fname, :contact_lname, :contact_title, 
                                     :city, :state, :status_id)
    end
end
