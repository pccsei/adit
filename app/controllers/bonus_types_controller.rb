class BonusTypesController < ApplicationController
  before_action :set_bonus_type, only: [:edit, :update, :destroy]
  
  def index
    @bonuses = BonusType.where(is_active: true)
    # render text: session[:my_previous_url]
    session[:my_previous_url] = nil
  end
  
  def new
    @bonus_type = BonusType.new
  end

  def create
    @bonus_type = BonusType.new(bonus_type_params)

    if @bonus_type.save
      if session[:my_previous_url] == users_path
        redirect_to :controller => 'users', :action => 'index', :bonus_type => @bonus_type
      else
        redirect_to bonus_types_path, notice: 'Bonus was successfully created.'
      end
    else
      render action: 'new' 
    end
  end

  def edit
  end

  def update
    # If it works let the user know.
    # render text: params['bonus_name']
    if BonusType.update_bonus(@bonus_type.id, get_current_project, bonus_type_params)
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
