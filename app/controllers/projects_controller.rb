class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers

  # GET /projects
  def index

    @project  = get_current_project
    @archived_projects = Project.non_archived.where('is_active = ?', false)
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
    if @project.use_max_clients == true
      @project.max_high_priority_clients = 0
      @project.max_medium_priority_clients = 0
      @project.max_low_priority_clients = 0
    else 
      @project.max_clients = 0
    end

      if @project.save
         set_selected_project(@project)
         Ticket.createTickets(@project)
         redirect_to users_path, notice: 'Project was successfully created.'
      else
         render action: 'new' 
      end

  end

  # PATCH/PUT /projects/1
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
      else
        @archived_projects = Project.non_archived.where('is_active = ?', false)
        format.html { render action: 'index' }
      end
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
    selected_project = Project.find(project_id)
    set_selected_project(selected_project)
    redirect_to projects_url, notice: 'You are now viewing the ' + selected_project.semester + ' ' +
                                          selected_project.year.to_s + ' project.'
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
                                      :use_max_clients, :project_type_id, :is_active)
    end
end
