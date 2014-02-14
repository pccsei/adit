class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers

  # GET /projects
  def index
    @projects = Project.all
    
    @current_projects  = Project.current
    @archived_projects = Project.archived 
    
    #hi = params['input']
    #if hi
    #  render text: hi
    #end
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
    @project.is_active = 1

    respond_to do |format|
      if @project.save
        create_tickets(@project)
        set_selected_project(@project)
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.html { redirect_to users_path, notice: 'Project was successfully created.' }

      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /projects/1
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
      else
        format.html { render action: 'edit' }
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
  
  # This is in the tickets controller currently....don't know if want to delete
  # Create the tickets and move to the next step, which is to add students
  # def create_tickets(project)
    # clients = Client.all
      # clients.each do |c|
      # ticket = c.tickets.create(
         # project_id: project.id,
         # priority_id: 2) # Will need a method to calculate)
       # ticket.save
    # end    
  # end
  
  def select_project
    project_id = params['input']
    selected_project = Project.find(project_id)
    set_selected_project selected_project
    redirect_to users_url #projects_url
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
                                      :use_max_clients, :project_type_id, :is_active, :ticket_close_time)
    end
end
