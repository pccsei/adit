class ActionsController < ApplicationController
  before_action :set_action, only: [:show, :edit, :update, :destroy]

  # GET /actions
  # GET /actions.json
  def index
    @actions = Action.all
  end

  # GET /actions/1
  # GET /actions/1.json
  def show
  end

  # GET receipts/:id/actions/new
  def new
    @action = Action.new(:receipt_id => params[:receipt_id])
    Action.new_action(@action, Receipt.find(@action.receipt_id), params[:action_type_name])
  end

  # GET /actions/1/edit
  def edit
  end

  # POST /actions
  # POST /actions.json
  def create
    @action = Action.new(action_params)
    receipt = Receipt.find(@action.receipt_id)

    @action, receipt, next_action, new_action = Action.create_action(params[:price], params[:page], params[:payment_type], params[:presentation], params[:sale], @action, receipt)

    respond_to do |format|
      if @action.save && receipt.save
         if new_action
           new_action.save
         end
         if next_action
           next_action.save
         end
        format.html { redirect_to(my_receipts_path(id: @action.receipt.user_id), notice: 'You successfully updated your client') }
        format.json { render action: 'show', status: :created, location: @action }
      else
        format.html { render action: 'new' }
        format.json { render json: @action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actions/1
  # PATCH/PUT /actions/1.json
  def update
    respond_to do |format|
      if @action.update(action_params)
        format.html { redirect_to @action, notice: 'Action was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /actions/1
  # DELETE /actions/1.json
  def destroy
    receipt = Receipt.find(@action.receipt_id)
      
    Action.delete_activity(@action, receipt)

    respond_to do |format|
      format.html { redirect_to :back, 
                      notice: "You have successfully deleted that entry." }
      # format.html { redirect_to receipt_path(@action.receipt),
                      # notice: "You have successfully deleted that entry." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_action
      @action = Action.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def action_params
      params.require(:foo).permit(:id, :points_earned, :user_action_time, :action_type_id, :receipt_id, :comment)
    end
end
