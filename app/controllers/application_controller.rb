class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :signed_in_user
  protect_from_forgery with: :exception

  include SessionsHelper
               helper_method :get_current_project # helper_method allow methods to be used in views
               helper_method :are_tickets_open  
               helper_method :get_selected_project
               helper_method :set_selected_project
               helper_method :get_section           
                            
  #$selected_project = Project.last
  $selected_section = "all"

  def get_current_project
    project = Project.find_by is_active: '1'
    return project
  end
  
  def get_selected_project
    Project.find(session[:selected_project_id]) || Project.last
  end

  def set_selected_project(project)
    session[:selected_project_id] = project.id
  end

  def set_selected_section section
    $selected_section = section
  end

  def get_section
    return $selected_section
  end

   # Restricts access to only teachers 
   def only_teachers
      if current_user.role != 3
        redirect_to signin_path # What should we redirect to?
      end
   end
   
   # Restricts access to only teachers and student managers
   def only_leadership
     if current_user.role == 1 
       redirect_to signin_path # What should we redirect to?
     end
   end
   
   def signed_in_user
     unless signed_in?
       store_location
       redirect_to signin_url, notice: "Please sign in"
     end
   end
  
end
