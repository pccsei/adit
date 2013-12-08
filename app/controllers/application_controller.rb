class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
               helper_method :get_current_project # helper_method allow methods to be used in views
               helper_method :are_tickets_open  
               helper_method :get_selected_project
               helper_method :set_selected_project
               
  $selected_project = Project.last
            
  def get_current_project
    project = Project.find_by is_active: '1'
    return project
  end
  
  def get_selected_project
    $selected_project
  end
  
    def set_selected_project(project = Project.last)
      $selected_project = project
      return $selected_project 
    end
  
end
