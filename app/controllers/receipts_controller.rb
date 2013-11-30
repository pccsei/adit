class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  # GET /receipts
  # GET /receipts.json
  def index
    current_user = User.find(1)
    @active_tickets =  current_user.tickets.where("sale_value is NULL")
    @sold_tickets = current_user.tickets.where("sale_value is not NULL")
    
    @all_receipts = current_user.receipts
    @all_tickets = Ticket.all
    @released_tickets = Array.new  
    
    @all_receipts.each do |r|
      add_ticket = false
       @all_tickets.each do |t|
     if ((t.user_id != r.user_id) && (r.ticket_id == t.id))
           add_ticket = true
      end
    end
        if(add_ticket == true)
          @released_tickets << r
        end
    end
    return
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
        format.html { redirect_to clients_url, notice: 'Receipt was successfully created.' }
        format.json { render action: 'show', status: :created, location: @receipt }
      else
        format.html { render action: 'new' }
        format.json { render json: clients_url, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url }
      format.json { head :no_content }
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
