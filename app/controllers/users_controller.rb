class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers


  # GET /users
  # GET /users.json
  def index
    @users = User.order(sort_column + " " + sort_direction)

    # Move this code to the models when you have time
    all_teachers = User.all_teachers
    
    teacher_ids = []
    all_teachers.each do |t|
      teacher_ids << t.id
    end
    
    project_student_members = Member.project_members(get_selected_project).where.not(user_id: teacher_ids )
    
    student_users_for_selected_project = []
    project_student_members.each do |s|
      student_users_for_selected_project << (User.find(s.user_id))
    end
    
    @current_students = student_users_for_selected_project.zip(project_student_members)
       

    # set paraments for selected section
    @sections = []
    if params["section_option"]
      @selected_section = params["section_option"]
    else
      @selected_section = "all"
    end
     
    # Find sections for current project    
    @sections = (Member.where("project_id = ?", (get_selected_project).id).uniq!.pluck("section_number")) 
    
    # find student managers
    @student_managers = User.where(role: 2)
    #@student_managers.each do |user|
      #@student_manager_names = user.first_name + " " + user.last_name
    #end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #@member_teachers = Member.where("role = 3 AND project_id = ?", @project.id)
    #@section_numbers = member_teachers.section_number.uniq!
  end
  
  def teacher
    @users = User.all
  end
  
  def student_manager
    @users = User.all
  end
  
  def student_rep
  end
  
  def full_help
      @current_user.help = false
      @current_user.save
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def input_students_parse
    user_params = params['input']
    section_number = params['section']  
   
    User.parse_students(user_params, section_number, get_selected_project.id) 
    redirect_to users_url
  end
  
  
  
  def change_student_status
    students           = params[:students]
    choice             = params['selected_option']
    student_manager_id = params['student_manager']

    User.do_selected_option(students, choice, student_manager_id, get_selected_project)

    redirect_to users_url
  end
  
  def create_new_section
    @teacher = User.all_teachers.first
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    @user.role = 1

    all_student_ids = [] 
    User.all.each do |user|  
      all_student_ids.push(user.school_id)
    end

    if all_student_ids.include?(@user.school_id)
      @user_same = User.find_by! school_id: @user.school_id
      @user_same.school_id = @user.school_id
      @user_same.first_name = @user.first_name
      @user_same.last_name = @user.last_name
      @user_same.classification = @user.classification
      @user_same.box = @user.box
      @user_same.phone = @user.phone
      @user_same.email = @user.email
      @user_same.major = @user.major
      @user_same.minor = @user.minor   
      @user_same.save
      redirect_to @user_same
    
    else
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :created_at, :updated_at, :school_id, :role, :role,
                                   :email, :phone, :first_name, :last_name, :box, 
                                   :major, :minor, :classification, :remember_token)
    end
    
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
