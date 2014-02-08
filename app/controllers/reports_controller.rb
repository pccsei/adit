class ReportsController < ApplicationController
  
  def sales
    
  end
  
  # GET reports/student_summary
  def student_summary
    
       Struct.new("Student", :id, :first_name, :last_name, :student_manager,
                            :section, :open, :sold, :released, :sales, 
                            :points, :last_activity)
       
       @student_array = []                     
       index = 0
       @receipts = Receipt.selected_project_receipts(get_selected_project)
       @students = User.current_student_users(get_selected_project, get_selected_section)
       
       @students.each do |s|
          @student_array[index] = Struct::Student.new
          @student_array[index].id = s.id
          @student_array[index].first_name = s.first_name
          @student_array[index].last_name = s.last_name
          @student_array[index].student_manager = User.get_manager_name(s.id, get_selected_project)
          @student_array[index].section = User.get_section_number(s.id, get_selected_project)
          @student_array[index].open = (Receipt.open_clients(s.id, get_selected_project)).size
          @student_array[index].sold = (Receipt.sold_clients(s.id, get_selected_project)).size
          @student_array[index].released = (Receipt.released_clients(s.id, get_selected_project)).size
          @student_array[index].sales = Receipt.sales_total(s.id, get_selected_project)
          @student_array[index].points = Receipt.points_total(s.id, get_selected_project)
          
          index = index + 1
       end
  end
  
  # GET reports/team_summary
  def team_summary
    
  end
  
  def activity
    
  end
  
private

   def get_student_summary
     User.current_student_users(get_selected_project, get_selected_section)
   end
  
end