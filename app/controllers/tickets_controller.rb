class TicketsController < ApplicationController
  before_action :only_teachers, only: [:new, :create]

  def index

    @currentProject = Project.select('id, max_clients,  max_high_priority_clients, max_medium_priority_clients, max_low_priority_clients, tickets_close_time').where(is_active: true, id: Member.select('project_id').where(user_id: current_user.id)).first

    if params[:ajax] == 'update'
      updates = Ticket.updates(params[:timestamp])

    elsif params[:ajax] == 'getClient'

      if @currentProject.nil? # No current project
        updates = {'userMessage' => 'There is not a current project!'}

      else
        requested_ticket_priority_id = Ticket.find(params[:clientID]).priority_id
        if Ticket.more_clients_allowed(current_user, get_current_project, 1, requested_ticket_priority_id)
          allowed = true
        else
          allowed = false
=begin
        if @currentProject.use_max_clients
          # Check to see if the user has the max number of clients
          if Ticket.where('user_id = ? AND project_id = ?', current_user.id, get_current_project.id).size - (0) >= @currentProject.max_clients
            updates = {'userMessage' => '<span class="text-danger" id="ticket_message">You have reached the maximum number of clients!</span>'}
            allowed = false
          else
            allowed = true
          end
        else
          requested_ticket_priority_id = Ticket.find(params[:clientID]).priority_id

          case (requested_ticket_priority_id)
            when Priority.where("name = 'high'").first.id
              allowed = Ticket.more_high_allowed(current_user.id, get_selected_project) 
            when Priority.where("name = 'medium'").first.id
              allowed = Ticket.more_medium_allowed(current_user.id, get_selected_project)
            when Priority.where("name = 'low'").first.id
              allowed = Ticket.more_low_allowed(current_user.id, get_selected_project)
            else            
              allowed = false
          end
=end
        end

        if allowed
          grabbedTicket = false
          ticket        = nil          
          Ticket.transaction do
            ticket = Ticket.where('id = ? ',params[:clientID]).lock(true).first

            if ticket.nil?
              updates = {'userMessage' => '<span class="text-danger" id="ticket_message">Ticket does not exist for the current project</span'}
            else 
               # User is allowed to get a new client: Try to grab the client ticket               
               if no_holder(ticket.user_id)
                 ticket.user_id = current_user.id
                 ticket.save!
                 grabbedTicket = true
               else
                 updates = {'userMessage' => '<span class="text-danger" id="ticket_message">Someone already grabbed that client!!</span>'}
               end
            end
          end

          # This is done down here to allow the transaction above to finish as quickly as possible thus allowing the user to better grab the ticket
          if grabbedTicket
            updates = { 'Success' => 'You are now assigned to ' + Client.find(ticket.client_id).business_name.to_s,
                        'ticketPriority' => Priority.find(ticket.priority_id).name.to_s}
            Receipt.find_or_create_by(ticket_id: ticket.id, user_id: current_user.id)
          end
        else
          updates = {'userMessage' => '<p class="text-danger" id="ticket_message">You already have the max number of ' + Priority.find(requested_ticket_priority_id).name.to_s + ' priority clients.</p>'}
        end
      end 
     
    ## Added by Noah, ugly check for existence of current project, can remove once we've 
    ## cleaned up the program  
    elsif @currentProject              
      @tickets = Ticket.current_project(@currentProject.id)

      @clientsLeft  = Ticket.total_allowed_left(current_user.id, @currentProject)
      @highPriority = Ticket.high_allowed_left(current_user.id, @currentProject)
      @midPriority  = Ticket.medium_allowed_left(current_user.id, @currentProject)
      @lowPriority  = Ticket.low_allowed_left(current_user.id, @currentProject)

                  
    end
    
    respond_to do |format|      
        format.html 
        format.json { render json: updates}
    end    
        
  end

  def show
    
    # all client information that is not nil
    # comment for sure (explaination of the comment)
    # sale information
    
    @clientInfo = Client.find(Ticket.find(params[:id]).client_id)    
    
  end

  def new
    @ticket = Ticket.new
  end

  def edit
  end

  def create
    clients = Client.house
    clients.each do |c|
       ticket = c.tickets.create(
         project_id: get_selected_project.id,
         priority_id: 2,       # Will need a method to calculate)
         user_id: c.submitter) 
       ticket.save
    end
    respond_to do |format|
        format.html { redirect_to users_url, notice: 'Ticket was successfully created.' }
    end
  end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def assign_user
    current_user = 1
    ticket.user_id = current_user
    ticket.save
    respond_to do |format|
        format.html { redirect_to clients_url, notice: 'Client was successfully added.' }
    end
  end

  def release
    t = Ticket.find(params[:id])  
    # if the person accessing the page is a teacher or the ticket holder
    if params[:id] && (current_user.role == 3 || t.user_id = current_user.id)    
      t = Ticket.find(params[:id])
      t.user_id = 0
      t.save
      
      response = {"status" => "true"}  
    else 
      response = {"status" => "false"}
    end    
    respond_to do |format|
      format.js {render json: response}
    end
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url }
    end
  end
  
  #####################################################################################
  
  def get_sys_time
    render json: {"time" => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')}
  end
  
  #####################################################################################
  
  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:id, :created_at, :updated_at, :project_id, 
                                     :client_id, :user_id, :priority_id)
    end
    
    def no_holder(user)
      user.nil? || user == 0    
    end
    
end