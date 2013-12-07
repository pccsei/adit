class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  # GET /receipts
  # GET /receipts.json
  def index
    current_user = User.first
    @active_tickets =  current_user.tickets.where("sale_value is NULL OR sale_value = 0")
    @sold_tickets = current_user.tickets.where("sale_value is not NULL or sale_value != 0 ")  
    @all_receipts     = current_user.receipts
    @all_tickets      = Ticket.where("project_id = ?", get_current_project)
    @released_tickets = Array.new  
   
    @all_receipts.each do |r|
      @all_tickets.each do |t|
        if ((t.user_id != r.user_id) && (r.ticket_id == t.id))
          @released_tickets << t
        end
      end
    end


  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
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
      params[:receipt]
    end
end
