class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @pending_clients = Client.pending

    @clients = Client.all

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
