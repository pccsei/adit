class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
               helper_method :get_current_project # helper_method allow methods to be used in views
               helper_method :are_tickets_open  
  def get_current_project
    project = Project.find_by is_current_project: '1'
    return project
  end
  
end
