class BonusTypesController < ApplicationController
  before_action :set_bonus_type, only: [:edit, :update, :destroy]
  
  def index
    @bonuses = BonusType.where(is_active: true)
  end
  
  def new
    @bonus_type = BonusType.new
  end

  def create
  end

  def edit
  end

  def update
    # If it works let the user know.
    # render text: params['bonus_name']
    if BonusType.update_bonus(@bonus_type, get_current_project, params['bonus_name'], params['point_value'])
      redirect_to bonus_types_url, :notice => "The bonus was successfully updated."
    else
      redirect_to bonus_types_url, :notice => "The bonus was not updated."
    end
  end

  def destroy
    message = BonusType.inactivate_bonus(@bonus_type, get_current_project)
      redirect_to bonus_types_url, :notice => message
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bonus_type
      @bonus_type = BonusType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bonus_type_params
      params.require(:bonus_type).permit(:id, :name, :is_active, :point_value)
            
    end
  
end
