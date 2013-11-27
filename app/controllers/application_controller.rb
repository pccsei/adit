class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
               helper_method :get_current_project
  
  def get_current_project
    project = Project.find_by "project_end > ?", Time.now
    return project
  end
end
