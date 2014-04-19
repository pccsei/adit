class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers
  skip_before_action :must_have_project


  # GET /projects
  def index

    @project  = get_current_project
    @archived_projects = Project.non_archived.where('is_active = ?', false)
    
  end

  def convert_to_excel   
    # All these instance variables are for the use of converting to excel
    @sales, @sale_total, @student_array, @student_totals, @team_data, @team_totals, @clients,
    @activities, @activity_totals, @bonuses, @bonus_total_points, @end_data, @end_sale_total, 
    @select_students, @all_teachers, @current_teachers = Project.all_to_excel(get_selected_project, current_user)
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

      if @project.save
         set_selected_project(@project)
         set_selected_section("all")
         Ticket.createTickets(@project)
         redirect_to users_path, notice: 'Project was successfully created.'
      else
         render action: 'new' 
      end

  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
       if @project.is_active
         set_selected_project(@project)
         message = "The #{@project.semester} #{@project.year} project was successfully updated."
       else
         message = "The #{@project.semester} #{@project.year} project was successfully archived."
       end
       redirect_to projects_path, notice: message 
    else
       render action: 'edit'
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
    end
  end

  
  def select_project
    project_id = params['input']
    if project_id.present?
      selected_project = Project.find(project_id)
      set_selected_project(selected_project)
      if selected_project.is_active
        set_selected_section(nil)
        get_selected_section
      else
        set_selected_section("all")
      end
      redirect_to projects_url, notice: 'You are now viewing the ' + selected_project.semester + ' ' +
                                            selected_project.year.to_s + ' project.'
    else
      redirect_to projects_url, notice: 'Please select a project to view.'
    end
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:id, :year, :semester, :tickets_open_time, :tickets_close_time, 
                                      :comment, :created_at, :updated_at, :max_clients, 
                                      :max_high_priority_clients, :max_low_priority_clients, :max_medium_priority_clients, 
                                      :project_type_id, :is_active)
    end
end
