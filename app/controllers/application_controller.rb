class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
               helper_method :get_current_project
  
  def are_tickets_open
    project = Project.find_by "project_end > ? && project_start < ? ", Time.now, Time.now
    return project
  end
  
  def get_current_project
    project = Project.find_by is_current_project: '1'
    return project
  end
  
end
