class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update ]
  before_action :only_teachers, except: [:unauthorized, :need_help, :download_help]
  skip_before_action :must_have_project, only: :unauthorized

  # GET /users
  # GET /users.json
  def index
    # If the bonus type is part of the parameters passed to this page, find the bonus type. This is used for the dropdowns in the view.
    if params[:bonus_type]
      @bonus_type = BonusType.find(params[:bonus_type])
    end

    @current = self.current_user
    @users = User.all
    @bonus_types = BonusType.where(is_active: true)
      
    @selected_section = get_selected_section
    @select_students = User.get_student_info(get_selected_project, get_selected_section, TEACHER)
    
    # Get array of all sections
    @sections = get_array_of_all_sections(get_selected_project)

    # find student managers
    @student_managers = User.get_managers_from_current_section(get_selected_project, get_selected_section)
    
    # For after creating a new bonus. Normally using the session variable is not the best way to do things.
    session[:my_previous_url] = users_path

    #if params[:section_option]
    #  set_selected_section(params[:section_option])
    #end
    # respond_to do |format|
    #     format.html 
    #     format.js
    #     format.xls
    # end
  end

  def unauthorized    
  end
  
  def download_help
    if current_user.role == TEACHER
      send_file("#{Rails.root}/public/Teacher_User_Manual.docx", :filename => "Adit_Teacher_User_Manual.docx", :type => "application/docx")
    else
      send_file("#{Rails.root}/public/Student_User_Manual.docx", :filename => "Adit_Student_User_Manual.docx", :type => "application/docx")
    end
  end

  # Add a new teacher to the section
  def another_teacher_to_section   
    User.create_new_section(params[:new_teacher_to_add], params[:section], session[:selected_project_id])
    user = User.find(params[:new_teacher_to_add])

    redirect_to users_teachers_path, notice: "#{user.first_name} #{user.last_name} was added to section #{params[:section]}."
  end

  # Delete the old teacher Member and add a new teacher member
  def change_teacher
    member = Member.find(params[:member_id])
    user = User.find(params[:teacher_to_change_to])
    
    User.change_teacher(user.id, member)

    redirect_to users_teachers_path, notice: "#{user.first_name} #{user.last_name} is now a teacher of section #{member.section_number}."
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    #@member_teachers = Member.where("role = TEACHER AND project_id = ?", @project.id)
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
    section_number = params['section']  

    User.create_new_section(params[:teachers], section_number, session[:selected_project_id])
    set_selected_section(section_number)
    redirect_to users_url,  notice: "You are now viewing your newly created section #{section_number}."
  end
  
  # Goes to the help page
  def need_help  
  end

  # GET /users/new
  def new
    if params[:id]
      @user = User.find(params[:id])
      flash.now[:info] = "Update this student and submit form to add him to the current project."
      @create_flag = true
    else
      @user = User.new
    end
    
    section_options = get_array_of_all_sections(get_selected_project)
    section_options.delete('all')
    @sections = section_options
  end

  # Get /users/new_teacher
  def new_teacher
    @user = User.new
  end

  def set_section
    set_selected_section(params["section_option"])
    
    respond_to do |format|
        format.html { redirect_to(:back) } 
        format.js 
    end
  end

  # GET /users/1/edit
  def edit
    section_options = get_array_of_all_sections(get_selected_project)
    section_options.delete('all')
    @sections = section_options
  end

  def input_students_parse
    user_params = params['input'].strip

    message = User.parse_students(user_params, get_selected_section, session[:selected_project_id]) 
       
    redirect_to users_url, notice: message || "Import from Excel Successful!"
  end

  def change_student_status
    students           = params[:students]
    choice             = params['selected_option']
    student_manager_id = params['student_manager']
    bonus_type_id      = params['bonus_type']

    # I temporarily have these choices in the controller because it calls an application controller function
    # if choice == "Show Only Inactive Students"
    #   set_students_to_show(2)
    # elsif choice == "Show only Active Students"
    #   set_students_to_show(1)
    # elsif choice == "Show Both Inactive and Active Students"
    #   set_students_to_show(3)
    # else
    
    # end

    # '' represents if the choice is just left as the default
    if choice != ''
      if students
        if choice != 'Add to Team' || student_manager_id
          success_state, message = User.do_selected_option(students, choice, student_manager_id, get_selected_project, bonus_type_id)
          if success_state == 'success'
            redirect_to users_url, :flash => { :success => message }
          elsif success_state == 'error'
            redirect_to users_url, :flash => { :error => message }
          else
            redirect_to users_url, :flash => { :notice => message }
          end
        else
          redirect_to users_url, :flash => { :error => "No Team Leader Selected." } 
        end
      else 
        redirect_to users_url, :flash => { :error => "No Students Selected." }      
      end
    else
      redirect_to users_url, :flash => { :error => "No Option Selected." }
    end
  end


  def delete_member
    member =  Member.find
  end
  
  # POST /users
  # POST /users.json
  def create
    if (User.find_by school_id: params[:user][:school_id])
       @user = User.find_by school_id: params[:user][:school_id]
       @user.update_attributes(user_params)
    else
       @user = User.new(user_params)
    end
        if @user.save

          if @user.role != TEACHER
            @member = Member.new
            @member.user_id = @user.id
            @member.project_id = session[:selected_project_id]
            @member.section_number = params[:section_number]
            @member.is_enabled = true
            @member.save
            redirect_to users_path, notice: @user.first_name + " " + @user.last_name + ' was successfully created and added to this section.' 
          else
           redirect_to users_teachers_path, notice: @user.first_name + " " + @user.last_name + ' was successfully created and added to the teacher roster.'
          end
        else
          render action: 'new' 
        end     
  end

  def duplicate_student
    if params[:student]
      @user = User.find_by school_id: params[:student]
    end
    
    if @user && @user.members.find_by(project_id: get_selected_project.id)
      @message = "member"
    elsif @user
      @message = "data"
      @section_number = get_selected_section
    end
    
    # if user
       # render text: "user.id"
    # else
      # render html: "hi"
    # end
    # else
      # redirect_to users_url
    # end
    respond_to do |format|
      format.js
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
          @member.is_enabled = true
          @member.section_number = params['section_number']
          @member.save
        end
        if @user.role != TEACHER
          member = Member.find_by(user_id: @user.id, project_id: get_selected_project)
          member.section_number = params['section_number']
          member.save
        end

        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
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
    user = User.find(member.user_id)
    Member.change_student_status(member)
    if member.is_enabled == true
      redirect_to users_url, :flash => { :success => "#{user.first_name} #{user.last_name} has been enabled." }
    else
      redirect_to users_url, :flash => { :success => "#{user.first_name} #{user.last_name} has been disabled." }
    end
  end
  
  def delete_incorrect
    user = User.find(params[:id])
    user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def remove_member
     member = Member.find(params[:id])
     member.delete
     redirect_to users_teachers_path, 
        notice: "#{member.user.first_name} #{member.user.last_name} was successfully removed from section #{member.section_number}."
  end
  # FIX - needs to find the project and section that teacher is being removed from before the delete
  def destroy
    member = Member.find_by(user_id: @user)

    member.delete
    redirect_to users_teachers_path
  end

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

  def tickets_left
    
    render json: {'Total'  => Ticket.total_allowed_left(current_user.id, get_current_project),
                  'High'   => Ticket.high_allowed_left(current_user.id, get_current_project),
                  'Medium' => Ticket.medium_allowed_left(current_user.id, get_current_project), 
                  'Low'    => Ticket.low_allowed_left(current_user.id, get_current_project)}
  end

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
