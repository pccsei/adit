class SessionsController < ApplicationController
  
  def new
    
  end
  
  def create
    user = User.find_by(school_id: params[:school_id])
    if user && User.authenticate(params[:school_id], params[:password])
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
  
end