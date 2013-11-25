class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  


  # GET /users
  # GET /users.json
  def index
    @users = User.all
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
  
   # Delete the header line   
    no_description_bar = user_params.split("\n")[1..-1] 
    
      
    all_student_info = no_description_bar
    
   # Parse the input 
    for i in 0..all_student_info.count-1
      single_student_info = all_student_info[i].split("\t")
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
    @user.save
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


end
