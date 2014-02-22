class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers, except: [:unauthorized]

  # GET /users
  # GET /users.json
  def index
    @current = self.current_user
    @users = User.all
    
    @selected_section = get_selected_section
    @select_students = User.get_student_info(get_selected_project, get_selected_section)
    
    # Get array of all the incorrectly entered students
    @incorrect_students = User.incorrect_students
    
    # Get array of all sections
    @sections = get_array_of_all_sections(get_selected_project)

    # find student managers
    @student_managers = User.where(role: 2)
    
    #if params[:section_option]
    #  set_selected_section(params[:section_option])
    #end
    respond_to do |format|
        format.html 
        format.js 
    end
  end

  def unauthorized    
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    #@member_teachers = Member.where("role = 3 AND project_id = ?", @project.id)
    #@section_numbers = member_teachers.section_number.uniq!
  end
  
  def teachers
     @teachers = User.all_teachers
     all_students = User.all_students
    
     student_ids = []
     all_students.each do |t|
       student_ids << t.id
     end
    
    project_teacher_members = Member.project_members(get_selected_project).where.not(user_id: student_ids )
    
    teacher_users_for_selected_project = []
    project_teacher_members.each do |s|
      teacher_users_for_selected_project << (User.find(s.user_id))
    end
    
    @current_teachers = teacher_users_for_selected_project.zip(project_teacher_members)
  end
  
  def student_manager
    @users = User.all
  end
  
  def create_new_section
    @teacher = User.all_teachers.first
    members = Member.all
    @selection = Array[] 
    @good_selection = Array[1,2,3,4,5,6,7,8,9,10]
    for i in 1..10 
      members.each do |member| 
        if (i == member.section_number && member.project_id == session[:selected_project_id] && !@selection.include?(i)) 
          @selection.push(i) 
        end
      end 
    end 
    @good_selection = @good_selection - @selection 
  end

  def assign_teacher_to_section
    teacher = params[:school_id]
    section_number = params['section']  

    User.create_new_section(teacher[:id], section_number, session[:selected_project_id])
    set_selected_section(section_number)
    redirect_to users_url  
  end

  def student_rep
  end
  
  # Need to get the .help set to 0....it's not right now
  def need_help
    @current_user.help = 0
    @current_user.save    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def set_section
    # set paraments for selected section
    set_selected_section(params["section_option"])
    
    respond_to do |format|
        format.html { redirect_to(:back) } 
        format.js 
    end
  end

  # GET /users/1/edit
  def edit
  end

  def input_students_parse
    user_params = params['input']

    User.parse_students(user_params, get_selected_section, session[:selected_project_id])

    redirect_to users_url
  end
  
  def change_student_status
    students           = params[:students]
    choice             = params['selected_option']
    student_manager_id = params['student_manager']

    User.do_selected_option(students, choice, student_manager_id, get_selected_project)

    redirect_to users_url
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    @user.role = 1
    @user.help = true

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
          @member = Member.new
          @member.user_id = @user.id
          @member.project_id = session[:selected_project_id]
          @member.section_number = get_selected_section
          @member.is_enabled = true
          @member.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render action: 'index', status: :created, location: @user }
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
          @member = Member.new
          @member.user_id = @user.id
          @member.project_id = session[:selected_project_id]
          @member.section_number = get_selected_section
          @member.is_enabled = true
          @member.save
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
  # Deletes the Member, not the user.
  def change_is_enabled
    member = Member.find_by user_id: params[:id]
    member.is_enabled ? member.is_enabled = false : member.is_enabled = true
    member.save!
    redirect_to users_path
  end
  
  def delete_incorrect
    user = User.find(params[:id])
    user.destroy
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
end
