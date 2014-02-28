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
    @receipt = Receipt.find(@action.receipt_id)
    action_received = params[:action_type_name]

    if action_received == 'Sale'
      if @receipt.ticket.priority.name == 'high'
        @action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
        @action.points_earned = (ActionType.find_by(name: 'Old Sale')).point_value
      else
        @action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
        @action.points_earned = (ActionType.find_by(name: 'New Sale')).point_value
      end
    else
      @action.action_type_id = (ActionType.find_by(name: action_received)).id
      @action.points_earned = (ActionType.find_by(name: action_received)).point_value
    end

  end

  # GET /actions/1/edit
  def edit
  end

  # POST /actions
  # POST /actions.json
  def create
    @action = Action.new(action_params)
    receipt = Receipt.find(@action.receipt_id)

    action_name = @action.action_type.name

    if action_name == 'First Contact'
       receipt.made_contact = true
    elsif action_name == 'Presentation'
      receipt.made_presentation = true
    else
      receipt.made_sale    = true
      receipt.sale_value   = params[:price]
      receipt.page_size    = params[:page]
      receipt.payment_type = params[:payment_type]
    end

    if params[:presentation]
      new_action                  = Action.new
      new_action.user_action_time = @action.user_action_time
      new_action.comment          = @action.comment
      new_action.action_type_id   = (ActionType.find_by(name: 'Presentation')).id
      new_action.receipt_id       = @action.receipt_id
      new_action.points_earned    = (ActionType.find_by(name: 'Presentation')).point_value
      receipt.made_presentation   = true
    end

    if params[:sale]
      priority = receipt.ticket.priority.name
      next_action = Action.new
      if priority == 'high'
        next_action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
        next_action.points_earned  = (ActionType.find_by(name: 'Old Sale')).point_value
      else
        next_action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
        next_action.points_earned  = (ActionType.find_by(name: 'New Sale')).point_value
      end
      next_action.user_action_time = @action.user_action_time
      next_action.comment          = @action.comment
      next_action.receipt_id       = @action.receipt_id
      receipt.made_sale            = true
      receipt.sale_value           = params[:price]
      receipt.page_size            = params[:page]
      receipt.payment_type         = params[:payment_type]
    end

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
    if @action.action_type.name == 'Presentation'
      @action.receipt.made_presentation = false
    elsif @action.action_type.name == 'First Contact'
      @action.receipt.made_contact == false
    elsif @action.action_type.name == ('New Sale' || 'Old Sale')
      @action.receipt.made_sale == false
      @action.receipt.sale_value = 0
      @action.receipt.page_size = 0
      @action.receipt.payment_type = nil
    end
    @action.destroy
    respond_to do |format|
      format.html { redirect_to actions_url }
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
