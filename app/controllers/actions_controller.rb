class ActionsController < ApplicationController
  before_action :set_action, only: [:show, :edit, :update, :destroy]

  # GET receipts/:id/actions/new
  def new
    @action = Action.new(:receipt_id => params[:receipt_id])
    @receipt = Receipt.find(@action.receipt.id)
    Action.new_action(@action, @receipt, params[:action_type_name])
  end

  # GET /actions/1/edit
  def edit
  end

  # POST /actions
  # POST /actions.json
  def create
    receipt = Receipt.find(params[:receipt_id])

    # Prevents an empty time from being submitted with comments
    if params[:user_action_time].present?
       user_action_time = params[:user_action_time]
    else
      user_action_time = Time.now
    end       

    # Send the action to the model to be created
    if receipt
       message = Action.create_action(params[:price],   params[:page],             params[:payment_type],
                                      params[:comment], params[:contact],          params[:presentation], 
                                      params[:sale],    user_action_time, receipt)

       version_cleanup(receipt.user_id, "Receipt")
       version_cleanup(receipt.user_id, "Action")

       # The || will return message if present, else 'You successfully....'
       redirect_to receipt_path(id: receipt.id), notice: message || 'You successfully updated your client.'
    else
       # This will only be invoked if the user deliberately turned off javascript.
       redirect_to receipt_path(id: receipt.id), notice: 'There were errors saving your form. Please enable javascript.'
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
    # Find and delete the correct activity and update the receipt that it is associated with
    receipt = Receipt.find(@action.receipt_id)      
    Action.delete_activity(@action, receipt)
    
    # Enable undo of delete action
    undo_link = view_context.link_to('Undo', revert_action_version_path(@action.versions.where(whodunnit: current_user.id).last), method: 'post')

    redirect_to :back, notice: 'You have successfully deleted that entry. ' + undo_link
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
