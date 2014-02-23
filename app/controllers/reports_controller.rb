class ReportsController < ApplicationController
  before_action :must_have_project

  def sales
   @sections = get_array_of_all_sections(get_selected_project)

       Struct.new("Sale", :student_id, :manager_id, :time_of_sale, :company, :page_size,
                            :sale_amount, :first_name, :last_name, :section, :team_leader, :payment_type, 
                            :ad_status)

       @sale_total = 0  
       @sales = []                     
       index = 0
       # Changed function name to all sold clients because error was thrown
       @sold_receipts = Receipt.all_sold_clients_in_section(get_selected_project, get_selected_section)

       @sold_receipts.each do |r|
          @sales[index] = Struct::Sale.new
          @sales[index].student_id = r.user_id
          # @sales[index].manager_id = User.get_manager_name((r.user_id), get_selected_project).id  << Add this when ready for it
          @sales[index].first_name   = User.find(r.user_id).first_name
          @sales[index].last_name    = User.find(r.user_id).last_name
          @sales[index].time_of_sale = Action.find_by(receipt_id: r.id).user_action_time
          @sales[index].company      = Client.find(Ticket.find(r.ticket_id).client_id).business_name
          @sales[index].page_size    = r.page_size
          @sales[index].sale_amount  = r.sale_value
          @sale_total               += r.sale_value
          @sales[index].team_leader  = User.get_manager_name((r.user_id), get_selected_project)
          @sales[index].payment_type = r.payment_type
          @sales[index].section      = User.get_section_number(r.user_id, get_selected_project)
          if (Action.find_by(receipt_id: r.id).action_type_id)
            @sales[index].ad_status = ActionType.find(Action.find_by(receipt_id: r.id).action_type_id).name
          end
          index = index + 1
       end
  end
  
  # GET reports/student_summary
  def student_summary
   @sections = get_array_of_all_sections(get_selected_project)

       Struct.new("Student", :id, :first_name, :last_name, :student_manager,
                            :section, :open, :sold, :released, :sales, 
                            :points, :last_activity)

       Struct.new("Student_Totals", :total_open, :total_sold, :total_released, :total_sales, 
                    :total_points)
       
       @student_totals = Struct::Student_Totals.new
       @student_totals.total_open = 0
       @student_totals.total_sold = 0
       @student_totals.total_released = 0
       @student_totals.total_sales = 0
       @student_totals.total_points = 0
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
          @student_totals.total_open += @student_array[index].open
          @student_array[index].sold = (Receipt.sold_clients(s.id, get_selected_project)).size
          @student_totals.total_sold += @student_array[index].sold
          @student_array[index].released = (Receipt.released_clients(s.id, get_selected_project)).size
          @student_totals.total_released += @student_array[index].released
          @student_array[index].sales = Receipt.sales_total(s.id, get_selected_project)
          @student_totals.total_sales += @student_array[index].sales
          @student_array[index].points = Receipt.points_total(s.id, get_selected_project)
          @student_totals.total_points += @student_array[index].points
          @student_array[index].last_activity = Action.get_last_activity(s.id, get_selected_project)

          index = index + 1
       end
  end

  # GET reports/team_summary
  def team_summary
   @sections = get_array_of_all_sections(get_selected_project)

           Struct.new("Team", :id, :student_manager, :section, :open, :sold, :released, :sales, :points, :b)

           Struct.new("Team_Totals", :total_open, :total_sold, :total_released, :total_sales, 
                    :total_points)           
       
       @team_totals = Struct::Team_Totals.new
       @team_totals.total_open = 0
       @team_totals.total_sold = 0
       @team_totals.total_released = 0
       @team_totals.total_sales = 0
       @team_totals.total_points = 0
       @team_data = []                     
       index = 0
       @receipts = Receipt.selected_project_receipts(get_selected_project)
       @students = User.current_student_users(get_selected_project, get_selected_section)
       array_of_manager_ids = User.get_array_of_manager_ids_from_project_and_section(get_selected_project, get_selected_section)
       array_of_team_ids = []
       # render text: Member.find_by(user_id: 59).project_id
       # for i in array_of_team_ids
       #   array_of_team_ids[i]
       # end
       if array_of_manager_ids.present?
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
            @team_totals.total_open +=     @team_data[index].open
            @team_totals.total_sold +=     @team_data[index].sold
            @team_totals.total_released += @team_data[index].released
            @team_totals.total_sales +=    @team_data[index].sales
            @team_totals.total_points +=   @team_data[index].points

          index = index + 1
       end
       end
  end

  def activities
   @sections = get_array_of_all_sections(get_selected_project)

    Struct.new("Activity", :student_id, :manager_id, :time_of_activity, :first_name, :last_name, :section, :team_leader,
                        :company, :activity, :comments,  :points_earned, :cumulative_points_earned_on_client)

    Struct.new("Activity_Totals", :points_earned, :cumulative_points_earned_on_client)  

    @activity_totals = Struct::Activity_Totals.new
    @activity_totals.points_earned = 0
    @activity_totals.cumulative_points_earned_on_client = 0
    @activities = []                     
    index = 0
    all_current_activities = Action.all_actions_in_project(get_selected_project, get_selected_section)

    all_current_activities.each do |a|
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
      @activity_totals.points_earned += a.points_earned
      all_actions_for_receipt = Action.find_all_by_receipt_id(Receipt.find(a.receipt_id))
      for i in 0..Action.where("receipt_id = ?", a.receipt_id).all.count-1
        total_points += all_actions_for_receipt[i].points_earned
      end
      @activities[index].cumulative_points_earned_on_client = total_points
      @activity_totals.cumulative_points_earned_on_client += total_points
      @activities[index].comments = a.comment
      index = index + 1
    end
  end
  
private

   def get_student_summary
     User.current_student_users(get_selected_project, get_selected_section)
   end
  
end