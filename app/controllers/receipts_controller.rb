class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  
  # GET /receipts
  # GET /receipts.json
  def index
    redirect_to my_receipts_path(id: current_user.id)
  end
  
  def my_receipts
    if User.ids.include?(params[:id].to_i) && (((User.find(params[:id].to_i).id == current_user.id) || (current_user.role == TEACHER)))
        @student_user      =  User.find(params[:id])
        @active_receipts   = Receipt.open_clients(@student_user.id, get_selected_project)
        @sold_receipts     = Receipt.sold_clients(@student_user.id, get_selected_project)
        @released_receipts = Receipt.released_clients(@student_user.id, get_selected_project)
        @bonuses           = Bonuses.get_bonuses(@student_user.id, get_selected_project.id)
    else
      if current_user.role != TEACHER
        redirect_to my_receipts_path(id: current_user.id), alert: 'You have been redirected to your own page'
      else
        redirect_to users_path, alert: 'No student with that id.'
      end
    end
    
    if params[:page]
      session[:return_to] = params[:page]
    end
    
    # On the boxes themselves, client business name, total points, correct color, checkboxes empty or checked
    
    # For completed clients...name, total points, maybe sale information???
    
    # Released just points and name
  end

  # GET /receipts/1
  # GET /receipts/1.json
  # We can use this function to list the updates on a receipt
  def show

    if Receipt.ids.include?(params[:id].to_i)
       @receipt = Receipt.find(params[:id].to_i)
       if (current_user.role == TEACHER) || (@receipt.user_id == current_user.id)
          @action = Action.new(receipt_id: @receipt.id)
          @client = @receipt.ticket.client
       else
          redirect_to tickets_path, notice: "You cannot access another student's clients. Welcome to your home page!"
       end
    elsif current_user.role == TEACHER
       redirect_to users_path, notice: "There is no Client Activity page that matches the id received."
    else
       redirect_to tickets_path, notice: "You have been redirected to your home page because an invalid id was sent to the Client Activity page."
    end
      #@highestUserAction = Action.where("receipt_id = ?", params[:id]).maximum("action_type_id")    
      #@sale = Action.where("receipt_id = ? AND action_type_id = ?", params[:id], TEACHER) #may need to be fixed if the DB column is changed
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
        undo_link = view_context.link_to("undo", revert_version_path(@receipt.versions.sscoped.last), :method => :post)
        format.html { redirect_to @receipt, notice: "Receipt was successfully updated. #{undo_link}" }
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
      format.html { redirect_to receipts_url, :notice => "successfully destroyed " }
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
