class ReportsController < ApplicationController
  
  def sales
       Struct.new("Sale", :student_id, :manager_id, :time_of_sale, :company, :page_size,
                            :sale_amount, :first_name, :last_name, :section, :team_leader, :payment_type, 
                            :ad_status)
       
       @sales = []                     
       index = 0
       # Changed function name to all sold clients because error was thrown
       @sold_receipts = Receipt.all_sold_clients(get_selected_project)

       @sold_receipts.each do |r|
          @sales[index] = Struct::Sale.new
          @sales[index].student_id = r.user_id
          # @sales[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
          @sales[index].first_name = User.find(r.user_id).first_name
          @sales[index].last_name = User.find(r.user_id).last_name
          @sales[index].time_of_sale = Action.find_by(receipt_id: r.id).user_action_time
          @sales[index].company = Client.find(Ticket.find(r.ticket_id).client_id).business_name
          @sales[index].page_size = r.page_size
          @sales[index].sale_amount = r.sale_value
          @sales[index].team_leader = User.get_manager_name((r.user_id), get_selected_project)
          @sales[index].payment_type = r.payment_type
          @sales[index].section = User.get_section_number(r.user_id, get_selected_project)
          if (Action.find_by(receipt_id: r.id).action_type_id)
            @sales[index].ad_status = ActionType.find(Action.find_by(receipt_id: r.id).action_type_id).name
          end
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
           Struct.new("Team", :id, :student_manager, :section, :open, :sold, :released, :sales, :points, :b)
       
       @team_data = []                     
       index = 0
       @receipts = Receipt.selected_project_receipts(get_selected_project)
       @students = User.current_student_users(get_selected_project, get_selected_section)
       array_of_manager_ids = Array.new(Member.pluck(:parent_id).uniq!)
       array_of_manager_ids.delete(nil)
       array_of_manager_ids.delete_if{|id| Member.find_by(parent_id: id).project_id != get_selected_project.id}
       array_of_team_ids = []
       # for i in array_of_team_ids
       #   array_of_team_ids[i]
       # end

       for i in array_of_manager_ids
          @team_data[index] = Struct::Team.new
          @team_data[index].student_manager = User.get_manager_name(i, get_selected_project)
          @team_data[index].section = User.get_section_number(i, get_selected_project)
          @team_data[index].open = 0
          @team_data[index].sold = 0
          @team_data[index].released = 0
          @team_data[index].sales = 0
          @team_data[index].points = 0
          Member.find_all_by_parent_id(i).each do |s|
            @team_data[index].open += (Receipt.open_clients(s.user_id, get_selected_project)).size 
            @team_data[index].sold += (Receipt.sold_clients(s.user_id, get_selected_project)).size
            @team_data[index].released += (Receipt.released_clients(s.user_id, get_selected_project)).size
            @team_data[index].sales += Receipt.sales_total(s.user_id, get_selected_project)
            @team_data[index].points += Receipt.points_total(s.user_id, get_selected_project)
          end

          index = index + 1
       end
  end

  def activities
    Struct.new("Activity", :student_id, :manager_id, :time_of_activity, :first_name, :last_name, :section, :team_leader,
                        :company, :activity, :comments,  :points_earned, :cumulative_points_earned_on_client)


    @activities = []                     
    index = 0
    @all_project_activities = Action.all_actions_in_project(get_selected_project)

    @all_project_activities.each do |a|
      total_points = 0
      @activities[index] = Struct::Activity.new
      @activities[index].student_id = Receipt.find(a.receipt_id).user_id
      # @activities[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
      @activities[index].time_of_activity = a.user_action_time
      @activities[index].first_name = User.find(Receipt.find(a.receipt_id).user_id).first_name
      @activities[index].last_name = User.find(Receipt.find(a.receipt_id).user_id).last_name
      @activities[index].section = User.get_section_number(Receipt.find(a.receipt_id).user_id, get_selected_project)
      @activities[index].team_leader = User.get_manager_name((Receipt.find(a.receipt_id).user_id), get_selected_project)
      @activities[index].company = Client.find(Ticket.find(Receipt.find(a.receipt_id).ticket_id).client_id).business_name
      @activities[index].activity = ActionType.find(a.action_type_id).name
      @activities[index].points_earned = a.points_earned
      all_actions_for_receipt = Action.find_all_by_receipt_id(Receipt.find(a.receipt_id))
      for i in 0..Action.where("receipt_id = ?", a.receipt_id).all.count-1
        total_points += all_actions_for_receipt[i].points_earned
      end
      @activities[index].cumulative_points_earned_on_client = total_points
      @activities[index].comments = a.comment
      index = index + 1
    end
  end
  
private

   def get_student_summary
     User.current_student_users(get_selected_project, get_selected_section)
   end
  
end