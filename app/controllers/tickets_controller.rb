class TicketsController < ApplicationController
  before_action :only_teachers, only: [:new, :create]
  before_action :teacher_to_assign, only: :index
  
  def index

    @currentProject = Project.select('id, max_clients,  max_high_priority_clients, max_medium_priority_clients, max_low_priority_clients, tickets_close_time').find_by(is_active: true, id: Member.select('project_id').where(user_id: current_user.id))

    if params[:ajax] == 'update'
      updates = Ticket.updates(params[:timestamp])

    elsif params[:ajax] == 'getClient'

      if @currentProject.nil? # No current project
        updates = {'userMessage' => 'There is not a current project!'}
      else
        requested_ticket_priority_name = Ticket.find(params[:clientID]).priority.name
        if Ticket.more_clients_allowed(current_user, get_current_project, 1, requested_ticket_priority_name)
        
          grabbedTicket = false
          ticket        = nil          
          Ticket.transaction do
            ticket = Ticket.lock(true).find(params[:clientID])

            if ticket.nil?
              updates = {'userMessage' => 'Ticket does not exist for the current project'}
            else 
               # The user is allowed to get a new client: Try to grab the client ticket               
               if no_holder(ticket.user_id)
                 ticket.user_id = current_user.id
                 ticket.save!
                 grabbedTicket = true
               else
                 updates = {'userMessage' => 'Someone already grabbed that client!!'}
               end
               
              # This is done down here to allow the transaction above to finish as quickly as possible thus allowing the user to better grab the ticket
              if grabbedTicket
                updates = { 'Success'        => 'You are now assigned to ' + Client.find(ticket.client_id).business_name.to_s + '!',
                            'ticketPriority' => Priority.find(ticket.priority_id).name.to_s}
                            
                # Create a receipt for the user if he does nor already have one. A user will already have a receipt if he previously had the ticket and released it.
                Receipt.find_or_create_by(ticket_id: ticket.id, user_id: current_user.id) 
              end
            end
          end
        else
          updates = {'userMessage' => 'You already have the max number of ' + requested_ticket_priority_name + ' priority clients.'}
        end
      end 
     
    elsif @currentProject              
      @tickets      = Ticket.current_project(@currentProject.id)
      @clientsLeft  = Ticket.total_allowed_left(current_user.id,  @currentProject)
      @highPriority = Ticket.high_allowed_left(current_user.id,   @currentProject)
      @midPriority  = Ticket.medium_allowed_left(current_user.id, @currentProject)
      @lowPriority  = Ticket.low_allowed_left(current_user.id,    @currentProject)
    end
    
    respond_to do |format|      
        format.html 
        format.json { render json: updates}
    end        
  end
  
  def release
    t = Ticket.find(params[:ticket_id])
      
    # If the user accessing the page is a teacher or the ticket holder, allow the user to release the ticket
    if params[:ticket_id] && (current_user.role == 3 || t.user_id = current_user.id)
      redirectUser = t.user_id
      t.user_id    = 0
      t.save
      
      if params[:body] # Tag the ticket with a comment if a comment was entered      
        Comment.create(body: params[:body], ticket_id: params[:ticket_id], user_id: current_user.id);
      end
    else 
      redirectUser = current_user.id
    end
    
    @d = params[:release_ticket_id]
    
    redirect_to my_receipts_path(redirectUser)    
  end

  def teacher_to_assign
    if current_user.role == 3
       redirect_to clients_path, notice: "You have been redirected to the teacher's version of this page."
    end
  end
  
  # This function returns the current server time to the front end. It is used by app/assets/javascripts/controller/tickets.js in the updateClients() function.
  # When the user first visits the tickets page, the page grabs the server time and stores it as a timestamp. Then every x number of seconds, that timestamp is 
  # sent to the server. The server will respond with any data that has been modified after that time. 
  def get_sys_time
    render json: {"time" => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')} # UTC is used to standardize the time across the front and back end.
  end
  
  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:id, :created_at, :updated_at, :project_id, :client_id, :user_id, :priority_id)
    end
    
    def no_holder(user)
      user.nil? || user == 0    
    end    
end