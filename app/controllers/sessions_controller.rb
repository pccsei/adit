class SessionsController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new, :create]

  def new

  end


   # This is active directory authentication
   def create

      user = User.find_by school_id: params[:school_id]
      if user && (!Rails.env.production? || 
        (Rails.env.production? && User.authenticate(params[:school_id], params[:password])))
       sign_in(user)
       if user.role == 3
          redirect_back_or projects_path
       else
          redirect_back_or tickets_path
       end
     else
       flash.now[:error] = 'Invalid PCC ID or password'
       render 'new'
     end
  end

# This is the expo create function
=begin
  def create

    if params[:id] == 'teacher'
      users = User.where(role: 3).ids
      user = User.find(users.sample)
      sign_in(user)
      redirect_back_or projects_path
    elsif params[:id] == 'student'
      users = User.where(role: 1).ids
      user = User.find(users.sample)
      sign_in(user)
      redirect_back_or tickets_path
    else
      flash.now[:error] = 'Invalid school id or password'
      render 'new'
    end
  end
=end
  def destroy
    sign_out
    redirect_to signin_path
  end

# This function will work for everything except numbers in the following format: 01.....
# It's purpose is to determine whether a teacher or a student is logging in.
  def is_number?(string)
    (string.to_i.to_s == string)
  end
end
