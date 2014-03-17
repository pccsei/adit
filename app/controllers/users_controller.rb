class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :only_teachers, except: [:unauthorized, :need_help, :download_help]
  skip_before_action :must_have_project, only: :unauthorized

  # GET /users
  # GET /users.json
  def index
    @current = self.current_user
    @users = User.all
    
    @selected_section = get_selected_section
    @select_students = User.get_student_info(get_selected_project, get_selected_section, get_students_to_show)
    
    # Get array of all the incorrectly entered students
    @incorrect_students = User.incorrect_students
    
    # Get array of all sections
    @sections = get_array_of_all_sections(get_selected_project)

    # find student managers
    @student_managers = User.get_managers_from_current_section(get_selected_section)
    
    #if params[:section_option]
    #  set_selected_section(params[:section_option])
    #end
    respond_to do |format|
        format.html 
        format.js
        format.xls
    end
  end

  def unauthorized    
  end
  
  def download_help
    if current_user.role == 3
      send_file("#{Rails.root}/public/Teacher_Help.docx", :filename => "Teacher_Help.docx", :type => "application/docx")
    else
      send_file("#{Rails.root}/public/Student_Help.docx", :filename => "Student_Help.docx", :type => "application/docx")
    end
  end

  # Add a new teacher to the section
  def another_teacher_to_section   
    User.create_new_section(params["new_teacher_to_add"], params["section"], session[:selected_project_id])

    redirect_to users_teachers_path
  end

  # Delete the old teacher Member and add a new teacher member
  def change_teacher
    User.change_teacher(params["teacher_to_change_to"], Member.find(params["member_id"]))

    redirect_to users_teachers_path
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    #@member_teachers = Member.where("role = 3 AND project_id = ?", @project.id)
    #@section_numbers = member_teachers.section_number.uniq!
  end
  
  # Show teacher and assistants for section and allow for modifications
  def teachers
    @all_teachers = User.all_teachers
    @current_teachers = User.current_teachers(get_selected_project)
    @number_of_teachers_per_section = User.get_number_of_teachers_per_section(get_array_of_all_sections(get_selected_project), get_selected_project)     
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
  
  # Need to get the .help set to 0....it's not right now
  def need_help  
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # Get /users/new_teacher
  def new_teacher
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

    # I temporarily have these choices in the controller because it calls an application controller function
    if choice == "Show Only Inactive Students"
      set_students_to_show(2)
    elsif choice == "Show only Active Students"
      set_students_to_show(1)
    elsif choice == "Show Both Inactive and Active Students"
      set_students_to_show(3)
    else
      User.do_selected_option(students, choice, student_manager_id, get_selected_project)
    end

    redirect_to users_url
  end

  def delete_member
    member =  Member.find
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    # Why do we need this????????????????????????????????????????????????????????
    # if User.pluck(:school_id).include?(@user.school_id)
      # @user_same = User.find_by! school_id: @user.school_id
      # @user_same.school_id = @user.school_id
      # @user_same.first_name = @user.first_name
      # @user_same.last_name = @user.last_name
      # @user_same.classification = @user.classification
      # @user_same.box = @user.box
      # @user_same.phone = @user.phone
      # @user_same.email = @user.email
      # @user_same.major = @user.major
      # @user_same.minor = @user.minor   
      # @user_same.save
      # redirect_to @user_same
    # else
      respond_to do |format|
        if @user.save
          if @user.role != 3
            @member = Member.new
            @member.user_id = @user.id
            @member.project_id = session[:selected_project_id]
            @member.section_number = get_selected_section
            @member.is_enabled = true
            @member.save

          format.html { redirect_to users_path, notice: @user.first_name + ' was successfully created and added to this section.' }
          else
           format.html { redirect_to users_teachers_path, notice: @user.school_id + ' was successfully created and added to the teacher roster.'}
          end
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      # end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
          members = Member.all
          available = false
          members.each do |current_member|
            if current_member.user_id == @user.id
              available = true
            end
          end
          if available == false
            @member = Member.new
            @member.user_id = @user.id
            @member.project_id = session[:selected_project_id]
            @member.section_number = get_selected_section
            @member.is_enabled = true
            @member.save
          end
          
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Change the students status
  def change_is_enabled
    member = Member.find params[:id]
    Member.change_student_status(member)
    redirect_to :back
  end
  
  def delete_incorrect
    user = User.find(params[:id])
    user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def destroy
    member = Member.find_by(user_id: @user)

    member.destroy
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
###################################################################################################################
  def in_section
    
    if params[:sn]
    
      if params[:sn] == "all"
        response = User.current_student_users(get_selected_project).pluck(:school_id, :first_name, :last_name)
      else 
        response = User.current_student_users(get_selected_project, params[:sn]).pluck(:school_id, :first_name, :last_name)
      end
    
    else 
      response = {"Please Don't" => "Come Here...."}  
    end
    render json: response
  end
###################################################################################################################
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :created_at, :updated_at, :school_id, :role,
                                   :email, :phone, :first_name, :last_name, :box, 
                                   :major, :minor, :classification, :remember_token)
    end
end
