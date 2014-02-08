class ReportsController < ApplicationController
  
  def sales
       Struct.new("Sale", :student_id, :manager_id, :time_of_sale, :company, :page_size,
                            :sale_amount, :name, :team_leader, :payment_type, 
                            :ad_status)
       
       @sales = []                     
       index = 0
       # Changed function name to all sold clients because error was thrown
       @sold_receipts = Receipt.all_sold_clients(get_selected_project)
       @students = User.current_student_users(get_selected_project, get_selected_section)

       @sold_receipts.each do |r|
          @sales[index] = Struct::Sale.new
          @sales[index].student_id = r.user_id
          # @sales[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
          @sales[index].time_of_sale = r.updated_at
          @sales[index].company = Client.find(Ticket.find(r.ticket_id).client_id).business_name
          @sales[index].page_size = Ticket.find(r.ticket_id).page_size
          @sales[index].sale_amount = Ticket.find(r.ticket_id).sale_value
          @sales[index].name = User.find(r.user_id).first_name + " " + User.find(r.user_id).last_name
          @sales[index].team_leader = User.get_manager_name((r.user_id), get_selected_project)
          @sales[index].payment_type = Ticket.find(r.ticket_id).payment_type
          @sales[index].ad_status = Action_types.find(Action.find_by(receipt_id: ).action_type_id).name

          index = index + 1
       end
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
          @student_array[index].last_activity = Action.get_last_activity(s.id, get_selected_project)

          index = index + 1
       end
  end
  
  # GET reports/team_summary
  def team_summary
    
  end
  
  def activity
       @sales = []                     
       index = 0
       @activities = Receipt.sold_clients(get_selected_project)
       @students = User.current_student_users(get_selected_project, get_selected_section)

       @activities.each do |r|
          @sales[index] = Struct::Sale.new
          @sales[index].student_id = r.user_id
          # @sales[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
          @sales[index].time_of_sale = r.updated_at
          @sales[index].company = Client.find(Ticket.find(r.ticket_id).client_id).business_name
          @sales[index].page_size = Ticket.find(r.ticket_id).page_size
          @sales[index].sale_amount = Ticket.find(r.ticket_id).sale_value
          @sales[index].name = User.find(r.user_id).first_name + " " + User.find(r.user_id).last_name
          @sales[index].team_leader = User.get_manager_name((r.user_id), get_selected_project)
          @sales[index].payment_type = Ticket.find(r.ticket_id).payment_type
          @sales[index].ad_status = Status.find(Client.find(Ticket.find(r.ticket_id).client_id).status_id).status_type

          index = index + 1
       end
  end
  
private

   def get_student_summary
     User.current_student_users(get_selected_project, get_selected_section)
   end
  
end