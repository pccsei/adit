class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  
  # GET /receipts
  # GET /receipts.json
  def index
    redirect_to my_receipts_path(id: current_user.id)
  end
  
  def my_receipts
    if ((User.find(params[:id]).id == current_user.id) || current_user.role == 3)
      @student_user     =  User.find(params[:id])
    else
      redirect_to my_receipts_path(id: current_user.id), alert: 'You have been redirected to your own page'
    end
    
    if params[:page]
      session[:return_to] = params[:page]
    end
    
    @active_receipts   = Receipt.open_clients(@student_user.id, get_selected_project)
    @sold_receipts     = Receipt.sold_clients(@student_user.id, get_selected_project)
    @released_receipts = Receipt.released_clients(@student_user.id, get_selected_project)
    
    # On the boxes themselves, client business name, total points, correct color, checkboxes empty or checked
    
    # For completed clients...name, total points, maybe sale information???
    
    # Released just points and name
  end

  # GET /receipts/1
  # GET /receipts/1.json
  # We can use this function to list the updates on a receipt
  def show
    released_receipts = Receipt.released_clients(current_user.id, get_selected_project)
    @receipt = Receipt.find(params[:id])
    @released_receipt = false
    released_receipts.each do |released|
      if released.id == @receipt.id
        @released_receipt = true
      end
    end
    @client = @receipt.ticket.client            
      #@highestUserAction = Action.where("receipt_id = ?", params[:id]).maximum("action_type_id")    
      #@sale = Action.where("receipt_id = ? AND action_type_id = ?", params[:id], 3) #may need to be fixed if the DB column is changed
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  # POST /receipts.json
  def create
    current_user = 1
    @receipt = Receipt.new
    @client = Client.find(params[:client])
    @receipt.ticket_id = @client.id
    @receipt.user_id = current_user

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to tickets_assign_user_url }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:id, :created_at, :updated_at, :ticket_id, :user_id)
            
    end
end
