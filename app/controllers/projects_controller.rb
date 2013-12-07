class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
    
    hi = params['input']
    if hi
      render text: hi
    end
  end

  # GET /projects/1
  def show
    @project = get_selected_project
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
    @project.is_current_project = 1

    respond_to do |format|
      if @project.save
        create_tickets(@project)
        format.html { redirect_to projects_next_step_path, notice: 'Project was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /projects/1
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
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
  
  # Create the tickets and move to the next step, which is to add students
  def next_step
  end
  
  def create_tickets(project)
    clients = Client.all
      clients.each do |c|
      ticket = c.tickets.create(
         project_id: project.id,
         priority_id: 2) # Will need a method to calculate)
       ticket.save
    end    
  end
  
  def select_project
    project_id = params['input']
    set_selected_project project_id
    redirect_to projects_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:id, :year, :semester, :project_start, :project_end, 
                                      :comment, :created_at, :updated_at, :max_clients, 
                                      :max_green_clients, :max_white_clients, :max_yellow_clients, 
                                      :use_max_clients, :project_type_id, :is_active)
    end
end
