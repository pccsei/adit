class SessionsController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new, :create]
  
  def new
    
  end
  
  def create
    
    school_id = params[:school_id]
    
    if is_number?(school_id)
       user = User.find_by(school_id: school_id)
    else
      user = User.find_or_initialize_by(school_id: school_id)
      user.role = 3
      user.save     
    end
     
      if user #&& User.authenticate(school_id, params[:password])       
       sign_in(user)
       redirect_to '/clients'
     else
       flash.now[:error] = 'Invalid school id or password'
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