class ReportsController < ApplicationController
  before_action :only_teachers, only: [:sales, :activities, :end_of_semester_data]
  before_action :only_leadership

  def sales
    @sections = get_array_of_all_sections(get_selected_project)
    @selected_section = get_selected_section
    @current = self.current_user
    @sales, @sale_total = Report.sales(get_selected_project, get_selected_section)
  end
  
  # GET reports/student_summary
  def student_summary
    @sections = get_array_of_all_sections(get_selected_project)
    @selected_section = get_selected_section
    @current = self.current_user
    @student_array, @student_totals = Report.student_summary(get_selected_project, get_selected_section, current_user)
  end

  # GET reports/team_summary
  def team_summary
    @sections = get_array_of_all_sections(get_selected_project)
    @selected_section = get_selected_section
    @current = self.current_user
    @team_data, @team_totals = Report.team_summary(get_selected_project, get_selected_section)
  end

  # GET reports/activities
  def activities
    @sections = get_array_of_all_sections(get_selected_project)
    @selected_section = get_selected_section
    @current = self.current_user
    @activities, @activity_totals = Report.activities(get_selected_project, get_selected_section)
  end

  # GET reports/bonuses
  def bonus
    @sections = get_array_of_all_sections(get_selected_project)
    @selected_section = get_selected_section
    @current = self.current_user 
    @bonuses, @bonus_total_points = Report.bonus(get_selected_project, get_selected_section)
  end

  # GET reports/end_of_semester_data
  def end_of_semester_data
    @sections = get_array_of_all_sections(get_selected_project)
    @current = self.current_user
    @end_data, @end_sale_total = Report.end_of_semester_data(get_selected_project, get_selected_section)
  end

  # This method is just designed as a sort of read only manage section page for Student Manager's
  def team_data
    if current_user.role == TEACHER
      redirect_to reports_team_summary_path
    end
    @students = User.team_members(get_selected_project, current_user.id)
  end
  
  def delete_bonus
    Bonus.delete_bonus(Bonus.find(params[:bonus]), params[:all])

    redirect_to :back
  end

  def edit_bonus
    # render text: params[:bonus_id]
    Bonus.edit_bonus(Bonus.find(params[:bonus_id]), params[:bonus_points], params[:bonus_comment])

    redirect_to :back
  end

private
   def get_student_summary
     User.current_student_users(get_selected_project, get_selected_section)
   end
end