class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :signed_in_user
  protect_from_forgery with: :exception

  # Adding these helper methods enables them to be used in views also
  include SessionsHelper
  helper_method :get_current_project 
  helper_method :are_tickets_open  
  helper_method :get_selected_project
  helper_method :set_selected_project
  helper_method :get_selected_project
  helper_method :get_selected_section
  helper_method :set_selected_section
  
  # CONSTANTS
  TEACHER = 3
  STUDENT_REP = 1                     
  
  # This method will most likely be deleted soon, use selected methods below instead                          
  def get_current_project
    project = Project.find_by is_active: '1'
    return project
  end

  def set_selected_project(project)
    session[:selected_project_id] = project.id
  end
  
  def get_selected_project
    if session[:selected_project_id]
      Project.find(session[:selected_project_id])
    else
      set_selected_project(Project.non_archived.last)
      Project.non_archived.last
    end
  end

  def set_selected_section(section_number)
    session[:selected_section_id] = section_number
  end

  def get_selected_section
    if session[:selected_section_id]
       session[:selected_section_id]
    else
       "all"
    end
  end

  def get_array_of_all_sections(selected_project)
    selected_project_id = selected_project.id
    sections = (Member.where("project_id = ?", selected_project_id).uniq!.pluck("section_number"))
    sections.sort!
    sections.unshift("all")
  end

   # Restricts access to only teachers 
   def only_teachers
      if current_user.role != TEACHER
        redirect_to signin_path # What should we redirect to?
      end
   end
   
   # Restricts access to only teachers and student managers
   def only_leadership
     if current_user.role == STUDENT_REP 
       redirect_to signin_path # What should we redirect to?
     end
   end
   
   def signed_in_user
     unless signed_in?
       store_location
       redirect_to signin_url, notice: "Please sign in"
     end
   end
  
  # 
   def tooltipify(string, cellWidth = 12, className = "fullComment") # cell width was arbitrarily chosen  
     if string.length > cellWidth
       string[0..cellWidth - 3] << "..." << "<span class='#{className}'>#{string} </span>"
     else 
       string
     end 
   end
   
end
