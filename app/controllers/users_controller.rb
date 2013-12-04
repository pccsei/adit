class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # GET /users
  # GET /users.json
  def index
    @users = User.order(sort_column + " " + sort_direction)

    # set paraments for selected section
    @sections = []
    if params["section_option"]
      @selected_section = params["section_option"]
    else
      @selected_section = "all"
    end
     
    # find all sections that current students are a part of  
    User.all.each do |f|
      @sections.push(f.section)
    end 
    @sections.uniq!  
    
    # find student managers
    @student_managers = User.where(role: 2)
    @student_managers.each do |user|
      @student_manager_names = user.first_name + " " + user.last_name
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end
  
  def teacher
    @users = User.all
  end
  
  def student_manager
    @users = User.all
  end
  
  def student_rep
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
   
    # Delete the header line if present
    if user_params.include? "Course"
      no_description_bar = user_params.split("\n")[1..-1] 
      all_student_info = no_description_bar
    else
      all_student_info = user_params.split("\n")
    end
 
    all_student_ids = [] 
    User.all.each do |user|  
      all_student_ids.push(user.school_id)
    end

    # Parse the input
    for i in 0..all_student_info.count-1
      single_student_info = all_student_info[i].split("\t")
      if !all_student_ids.include?(single_student_info[1])
        @user = User.new
        @user.school_id = single_student_info[1]
        @user.first_name = single_student_info[2].split(", ")[1]
        @user.last_name = single_student_info[2].split(", ")[0]
        @user.classification = single_student_info[3]
        @user.box = single_student_info[5]
        @user.phone = single_student_info[6]
        @user.email = single_student_info[7]
        @user.major = single_student_info[8]
        @user.minor = single_student_info[9]
        @user.role = 1
        @user.section = section_number
        @user.save
      end
    end
    
    redirect_to users_url
  end
  
  
  
  def change_student_status
    students        = params[:students]
    choice          = params['selected_option']
    student_manager_id = params['student_manager']

    if student_manager_id
      student_manager = User.find(student_manager_id)
    end
    
    # do selected option, as long as some students are selected
    if students != nil
      if choice == "Promote_Student"
        for i in 0..students.count-1
          user = User.find(students[i])
          user.role = 2
          user.parent_id = user.first_name + " " + user.last_name        
          user.save
          end
        end

      if choice == "Demote_Student"
        for i in 0..students.count-1
          user = User.find(students[i])
          user.role = 1
          User.all.each do |user2|
            if user.parent_id == user2.parent_id
              user2.parent_id = nil
              user2.save
            end
          end 
          user.save
        end
      end
    
      if choice == "Delete_Student"
        for i in 0..students.count-1
          user = User.find(students[i])
          if user.role == 2
            User.all.each do |user2|
              if user.parent_id == user2.parent_id
                user2.parent_id = nil
                user2.save
              end
            end 
          end
          user.destroy
          user.save
        end
      end
    
    
      if choice == "Create_Team"
        for i in 0..students.count-1
          user = User.find(students[i])
          user.parent_id = student_manager.first_name + " " + student_manager.last_name 
          user.save
        end
      end
    end

    # obviously no students students need to be selected here  
    if choice == "Delete_Everybody"
      User.all.each do |f|
        f.destroy
        f.save
      end
    end

    redirect_to users_url
  end
  
  
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

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
      params.require(:user).permit(:id, :created_at, :updated_at, :school_id, :role, :section, :parent_id, :email, :phone, :first_name, :last_name, :box, :major, :minor, :classification)
    end
    
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
