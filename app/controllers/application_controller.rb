class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :signed_in_user
  protect_from_forgery with: :exception
  before_filter :must_have_project

  # Adding these helper methods enables them to be used in views also
  include SessionsHelper
  helper_method :get_current_project 
  helper_method :are_tickets_open  
  helper_method :set_selected_project
  helper_method :get_selected_project
  helper_method :get_selected_section
  helper_method :set_selected_section
  helper_method :get_current_student_project
  
  # CONSTANTS
  TEACHER = 3
  STUDENT_REP = 1                     
  

  def get_current_student_project
    get_current_project &&
        Member.where(user_id: current_user.id, project_id: get_current_project.id).present?
  end

  # This method will most likely be deleted soon, use selected methods below instead                          
  def get_current_project
    project = Project.find_by is_active: true
    return project
  end

  # 1 = active students only, 2 = inactive students only, 3 = all students
  def set_students_to_show(choice)
    session[:students_to_show] = choice
  end

  def get_students_to_show
    if session[:students_to_show]
      session[:students_to_show]
    else
      1
    end
  end

  def set_selected_project(project)
    session[:selected_project_id] = project.id
  end
  
  def get_selected_project
    if session[:selected_project_id]
      Project.find(session[:selected_project_id])
    elsif get_current_project
      set_selected_project(get_current_project)
      get_current_project
    elsif Project.non_archived.last
      set_selected_project(Project.non_archived.last)
      Project.non_archived.last
    else
      nil
    end
  end

  def set_selected_section(section_number)
    session[:selected_section_id] = section_number
  end

  def get_selected_section
    if session[:selected_section_id]
       session[:selected_section_id]
    else
      'all'
    end
  end

  def get_array_of_all_sections(selected_project)
    selected_project_id = selected_project.id
    sections = (Member.where('project_id = ?', selected_project_id).uniq!.pluck('section_number'))
    sections.sort!
    sections.unshift('all')
  end

   # Restricts access to only teachers 
   def only_teachers
      if current_user.role != TEACHER
        redirect_to users_unauthorized_path # What should we redirect to?
      end
   end
   
   # Restricts access to only teachers and student managers
   def only_leadership
     if current_user.role == STUDENT_REP 
       redirect_to users_unauthorized_path# What should we redirect to?
     end
   end
   
   def signed_in_user
     unless signed_in?
       store_location
       redirect_to signin_url
     end
   end
   
   def must_have_project
     if current_user.role == TEACHER
       if get_selected_project == nil
         redirect_to projects_url
       end
     elsif !get_current_student_project
       redirect_to no_project_path
     end

   end
   
end
