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
    #sale = (ActionType.find_by :name, "Old Sale").id
    #presentation =  (Action_Type.find_by :name, "Presentation").id
    #first_contact = (Action_Type.find_by :name, "First Contact").id
    #new_sale = (Action_type.find_by :name, "New Sale").id
    
    @action = Action.new(:receipt_id => params[:receipt_id])
    @receipt = Receipt.find(@action.receipt_id)
    if params[:action_type_name] == "Comment"
      @action.action_type_id = (ActionType.find_by(name: params[:action_type_name])).id    
    else
    if params[:action_type_name] != "Sale"
       @action.action_type_id = (ActionType.find_by(name: params[:action_type_name])).id
    else
      priority = @receipt.ticket.priority.name
      if priority == "high"
        @action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
      else
        @action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
      end
    end
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
    if @action.action_type.name != "Comment"
        if receipt.made_contact == true
           if receipt.made_presentation == true
             receipt.made_sale = true
             receipt.sale_value = params[:price]
             receipt.page_size = params[:page]
             receipt.payment_type = params[:payment_type]
           else
             receipt.made_presentation = true
           end
        else
           receipt.made_contact = true
        end
        if params[:presentation]
          new_action = Action.new
          new_action.user_action_time = @action.user_action_time
          new_action.comment = @action.comment
          new_action.action_type_id = (ActionType.find_by(name: 'Presentation')).id
          new_action.receipt_id = @action.receipt_id
          receipt.made_presentation = true
          new_action.save
        end
        
        # Two checks to make sure that sale checkbox was not submitted without presentation being accomplished
        if params[:sale] && (params[:presentation] || receipt.made_presentation == true)
        priority = receipt.ticket.priority.name
          new_action = Action.new
          if priority == "high"
             new_action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
          else
             new_action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
          end
          new_action.user_action_time = @action.user_action_time
          new_action.comment = @action.comment
          new_action.receipt_id = @action.receipt_id
          receipt.made_sale = true
          receipt.sale_value = params[:price]
          receipt.page_size = params[:page]
          receipt.payment_type = params[:payment_type]
          new_action.save
        end
        receipt.save
        else
          @action.user_action_time = Time.now
        end
    respond_to do |format|
      if @action.save
        format.html { redirect_to("/receipts/my_receipts/#{@action.receipt.user_id}", notice: 'You successfully updated your client') }
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
