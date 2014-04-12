class SessionsController < ApplicationController
  skip_before_filter :signed_in_user, :must_have_project

  def new

  end

=begin
   # This is active directory authentication
   def create

      user = User.find_by school_id: params[:school_id]
      if user && (!Rails.env.production? || 
        (Rails.env.production? && User.authenticate(params[:school_id], params[:password])))
       if user.role == 3
          sign_in(user)
          redirect_back_or projects_path
       else
          sign_in(user)
          redirect_back_or tickets_path
       end
     else
       flash.now[:error] = 'Invalid PCC ID or password'
       render 'new'
     end
  end

# This is the expo create function
=end

  def create

    if current_user.present?
      sign_out
    end
    
    if params[:id] == 'teacher'
      users = User.where(role: 3).ids
      if users.present?
         user = User.find(users.sample)
         sign_in(user)
         redirect_to users_path
      else
         flash.now[:error] = 'Currently, there are no teachers available, please try again later.'
         render 'new'
      end
    elsif params[:id] == 'student'
      users = User.where(role: 1).ids
      if users.present?
         user = User.find(users.sample)
         sign_in(user)
         redirect_to tickets_path
      else
         flash.now[:error] = 'Currently, there are no students available, please try again later.'
         render 'new'
      end
    else
      flash.now[:error] = 'Congratulations! You found a really bad error. Find a programmer ASAP.'
      render 'new'
    end
  end

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
