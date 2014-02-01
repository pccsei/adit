class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @pending_clients = Client.pending

    currentProject = Project.select("id, use_max_clients, max_green_clients, max_yellow_clients, max_white_clients").where("is_active = 1").first

    if params[:ajax] == "update"
      #@updates = Ticket.find(:all, :select => "id, user_id", :conditions => ["DATE(created_at) <= ?", params[:timestamp]])
      @updates =  Ticket.select("client_id, user_id").where("updated_at >= ?", params[:timestamp]).all      
      @updates << Time.now.strftime("%Y-%m-%d %H:%M:%S") # Append System Time
      
    elsif params[:ajax] == "getClient"      
      
      # Grab the current project 
      #currentProject = Project.select("id, use_max_clients, max_green_clients, max_yellow_clients, max_white_clients").where("is_current_project = 1").first
      
      if currentProject.nil? # No current project
        @updates = {"Error" => "There is not a current project!"}        
      else 
                
        #are these defined in the DB????
        green  = 1
        yellow = 2
        white  = 3    
        
        userID = "117567" # need to grab from server variable         
        user   = User.select("id, school_id").where("school_id = ?", userID).first #How to get user id from server variable?

        if user.nil? #make sure the user exists. Not redirecting because request is an ajax call
          @updates = {"Error" => "User does not exist in the database..."}
        else

          if (currentProject.use_max_clients) == 1
            # Check to see if the user has the max number of clients
            if Ticket.where("user_id = ?", user.school_id).size > currentProject.max_clients
              @updates = { error => "You have reached the maximum number of clients!"}
            end  
                  
          #check each color  
          elsif (Ticket.where("user_id = ? AND priority_id = ?", user.school_id, green)).size > currentProject.max_green_clients          
            @updates = { "Error" => "You have exceeded the number of allowed green clients"}          
          elsif (Ticket.where("user_id = ? AND priority_id = ?", user.school_id, yellow)).size > currentProject.max_yellow_clients
            @updates = { "Error" => "You have exceeded the number of allowed yellow clients"}          
          elsif (Ticket.where("user_id = ? AND priority_id = ?", user.school_id, white)).size > currentProject.max_white_clients
            @updates = { "Error" => "You have exceeded the number of allowed white clients"}          
          else 
            
            grabbedTicket = false
            ticket = nil;
            
            Ticket.transaction do                                      
              ticket = Ticket.where("client_id = ? AND project_id = ?", params[:clientID], currentProject.id).lock(true).first
              
              if ticket.nil?
                @updates = {"Error" => "Ticket does not exist for the current project"}
              else 
                 # User is allowed to get a new client: Try to grab the client ticket
                 
                 if ticket.user_id.nil? || ticket.user_id == 0
                   ticket.user_id = user.id
                   ticket.save!
                   @updates = { "Success" => "You got the client"}     
                   grabbedTicket = true         
                 else 
                   @updates = {"Someone already grabbed that client!!" => "(o_o')"}              
                 end   
              end
            end            
            
            # This is done down here to allow the transaction above to finish as quickly as possible thus allowing the user to better grab the ticket
            if grabbedTicket
              receipt = Receipt.where("ticket_id = ? AND user_id = ?", ticket.id, user.id).first
              
              if receipt.nil?
                Receipt.create(ticket_id: ticket.id, user_id: user.id)
              end              
            end            
          end
          
        end               
      end 
     
    ## Added by Noah, ugly check for existence of current project, can remove once we've 
    ## cleaned up the program  
    elsif currentProject    
      @tickets = Ticket.where("project_id = ?", currentProject.id)
    end
    
    respond_to do |format|      
        format.html 
        format.json { render json: @updates}
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end


  #used when the clients page pings the server to see if there are any new actions to be performed on the table
  
  #need to add the .js page 
  def ping
    
    
    #logger.debug("APPLICATION WAS SUCCESSFULLY PINGED")
    #logger.flush
    
    #updates = Ticket.find(:all, :select => "id, user_id", :conditions => ["DATE(created_at) >= ?", params[:timestamp]]) #this should give all the updates since the last ping. not sure though
    
    @up = Ticket.find(params[:id])
    render json: @up
    
    
    
    #how to return JSON???
           
  end

  def approve_client
    render text: approved = params['Approve']
    # params['disapprove']
    # if params['Approve']
    #   render text: "hi"
    # end
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    
    if !params[:ping].nil?
      return 0
    end
      
    
    
    @client = Client.new(client_params)
    
    # This line should eventually place the clients on the pneding clients list instead of straight into the db
    # @client.status_id = Status.where("status_type = ?", "Pending").pluck(:id) 

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
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

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
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
