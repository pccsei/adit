class UpdatesController < ApplicationController
  before_action :set_update, only: [:show, :edit, :update, :destroy]

  # GET /updates
  # GET /updates.json
  def index
    current_receipt = Receipt.first
    @updates = Update.where("receipt_id = ?", current_receipt.id)
    
    @update = Update.new
  end

  # GET /updates/1
  # GET /updates/1.json
  def show
    
    # quick fix for dev purposes only
    if params[:receipt_id].nil?
      params[:receipt_id] = Receipt.first.id
    end
    
    # Grab updates in reverse chronological order 
    @updates = Update.where("receipt_id = ?", params[:receipt_id]).order("created_at")
    
    if @updates.nil?
      @ERROR = "Updates is nil"
      
    else
            
      @highestUserAction = Action.where("receipt_id = ?", params[:receipt_id]).maximum("action_type_id")    
      @sale = Action.where("name = Sale") #may need to be fixed if the DB column is changed
      
    end
   
    
    
  end
  
=begin
  1) check to see if the receipt for which the updates are being requested belongs to the user
     (the ticket may not belong to the user, but the receipt will always belong to the user)
     
  2) grab all the updates related the the receipt from the update table. 
  
  3) grab the max action number for this receipt (see what the last action performed was)
      
    3a) if max action number is the same as sale action type number, display COMPLETED message
    
    3b) else show the last action performed (or the next action to be performed)
  
  4) Grab all the updates associated with the receipt (be sure to run the query to get updates in reverse chronological order using an ORDER BY)
  
  --do in the view--  
  5) display a text area and buttons for which update to say was done and a save button etc.
  
  6) Display each update done on the receipt. should include a text associated with each update (inside a hidden text area that will appear when edit is clicked), 
      pre-checked checkboxes indicating which actions were performed (these will also be editable) and the edit button
      
  x) Do we need the release button on this page too? 
     
=end

  

  # GET /updates/new
  def new
    @update = Update.new
    @receipt_id = params[:q1]
  end

  # GET /updates/1/edit
  def edit
  end

  # POST /updates
  # POST /updates.json
  def create
    @update = Update.new(update_params) # was giving ForbiddenAttributesError
    @update.id = params[:receipt_id]
    #how to get receipt id? 
    
    #@update = Update.new(comment_text: params[:update_comment_text])
    
    
    if !params[:first_contact].nil?
      Action.create(receipt_id: receipt_id)
    end
    if !params[:presentation].nil?
      
    end
    if !params[:sale].nil?
      
    end
       
    

    respond_to do |format|
      if @update.save
        format.html { redirect_to @update, notice: 'Update was successfully created.' }
        format.json { render action: 'show', status: :created, location: @update }
      else
        format.html { render action: 'new' }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /updates/1
  # PATCH/PUT /updates/1.json
  def update
    respond_to do |format|
      if @update.update(update_params)  # is giving ForbiddenAttributeError
        format.html { redirect_to @update, notice: 'Update was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updates/1
  # DELETE /updates/1.json
  def destroy
    @update.destroy
    respond_to do |format|
      format.html { redirect_to updates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update
      @update = Update.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.    
    def update_params
      params.require(:update).permit(:id, :is_public, :comment_text, :created_at, :updated_at, :receipt_id)
    end    
end