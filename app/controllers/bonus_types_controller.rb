class BonusTypesController < ApplicationController
  before_action :set_bonus_type, only: [:edit, :update, :destroy]
  
  def index
    @bonuses = BonusType.all
  end
  
  def new
    @bonus_type = BonusType.new
  end

  def create
  end

  def edit
  end

  def update
    redirect_to bonus_type_url, :notice => "Your bonus was successfully updated."
  end

  def destroy
    @bonus_type.destroy
      redirect_to bonus_type_url, :notice => "Your bonus was successfully destroyed."
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
