# This is only a convenient location to put all the report functions. It is obviously not an actual element in the database.
class Report 
  # The following functions are basically the same in format. Each just gets different data that is needed for the report pages.
  # The data is stored in structures. Also most of the totals are stored in structures except when only one total is needed like
  # in the sales function when the only total needed is sale_total. The main variable passed back is an a array of structures. 
  # The second variable passed back is either a single structure or single variable of total data.

  # Calculates all the sale information and totals.
  def self.sales project, section
    Struct.new("Sale", :student_id, :manager_id, :time_of_sale, :company, :page_size,
                       :sale_amount, :first_name, :last_name, :section, :team_leader, :payment_type, 
                       :ad_status)

    sale_total = 0  
    sales = []                     
    index = 0

    sold_receipts = Receipt.all_sold_clients_in_section(project, section)

    sold_receipts.each do |r|
      sales[index] = Struct::Sale.new
      sales[index].student_id   = r.user_id
      sales[index].first_name   = User.find(r.user_id).first_name
      sales[index].last_name    = User.find(r.user_id).last_name
      sales[index].time_of_sale = Action.find_by(receipt_id: r.id).user_action_time
      sales[index].company      = Client.find(Ticket.find(r.ticket_id).client_id).business_name
      sales[index].page_size    = r.page_size
      sales[index].sale_amount  = r.sale_value
      sale_total                += r.sale_value
      sales[index].team_leader  = User.get_manager_name((r.user_id), project)
      sales[index].payment_type = r.payment_type
      sales[index].section      = Member.get_section_number(r.user_id, project)
      if (Action.find_by(receipt_id: r.id).action_type_id)
        sales[index].ad_status  = ActionType.find(Action.find_by(receipt_id: r.id, action_type_id: [ActionType.find_by(name: "Old Sale").id,ActionType.find_by(name: "New Sale").id]).action_type_id).name
      end
      index = index + 1
    end

    return sales, sale_total
  end

  # Calculates all the student information and totals.
  def self.student_summary project, section, current_user
    Struct.new("Student", :id, :first_name, :last_name, :student_manager,
                          :section, :open, :sold, :released, :sales, 
                          :points, :last_activity)

    Struct.new("Student_Totals", :total_open, :total_sold, :total_released, :total_sales, 
                                 :total_points)

    student_totals = Struct::Student_Totals.new
    student_totals.total_open = 0
    student_totals.total_sold = 0
    student_totals.total_released = 0
    student_totals.total_sales = 0
    student_totals.total_points = 0
    student_array = []                     
    index = 0
    receipts = Receipt.selected_project_receipts(project)
    if current_user.role == TEACHER
      students = User.current_student_users(project, section)
    elsif Member.is_team_leader(Member.find_by(project_id: project, user_id: current_user))
      students = User.team_members(project, current_user.id)
    end

    students.each do |s|
      student_array[index] = Struct::Student.new
      student_array[index].id = s.id
      student_array[index].first_name = s.first_name
      student_array[index].last_name = s.last_name
      student_array[index].student_manager = User.get_manager_name(s.id, project)
      student_array[index].section = Member.get_section_number(s.id, project)
      student_array[index].open = (Receipt.open_clients(s.id, project)).size
      student_totals.total_open += student_array[index].open
      student_array[index].sold = (Receipt.sold_clients(s.id, project)).size
      student_totals.total_sold += student_array[index].sold
      student_array[index].released = (Receipt.released_clients(s.id, project)).size
      student_totals.total_released += student_array[index].released
      student_array[index].sales = Receipt.sales_total(s.id, project)
      student_totals.total_sales += student_array[index].sales
      student_array[index].points = Receipt.points_total(s.id, project)
      student_totals.total_points += student_array[index].points
      student_array[index].last_activity = Action.get_last_activity(s.id, project)
      index = index + 1
    end

    return student_array, student_totals
  end

  # Calculates all the team information and totals.
  def self.team_summary project, section
    Struct.new("Team", :id, :student_manager, :section, :open, :sold, :released, :sales, :points, :b)

    Struct.new("Team_Totals", :total_open, :total_sold, :total_released, :total_sales, 
                              :total_points)           

    team_totals = Struct::Team_Totals.new
    team_totals.total_open = 0
    team_totals.total_sold = 0
    team_totals.total_released = 0
    team_totals.total_sales = 0
    team_totals.total_points = 0
    team_data = []                     
    index = 0
    receipts = Receipt.selected_project_receipts(project)
    students = User.current_student_users(project, section)
    array_of_manager_ids = User.get_array_of_manager_ids_from_project_and_section(project, section)
    array_of_team_ids = []

    if array_of_manager_ids.present?
      for i in array_of_manager_ids
        team_data[index] = Struct::Team.new
        team_data[index].student_manager = User.get_manager_name(i, project)
        team_data[index].section = Member.get_section_number(i, project)
        team_data[index].open = 0
        team_data[index].sold = 0
        team_data[index].released = 0
        team_data[index].sales = 0
        team_data[index].points = 0
        Member.find_all_by_parent_id(i).each do |s|
          team_data[index].open += (Receipt.open_clients(s.user_id, project)).size 
          team_data[index].sold += (Receipt.sold_clients(s.user_id, project)).size
          team_data[index].released += (Receipt.released_clients(s.user_id, project)).size
          team_data[index].sales += Receipt.sales_total(s.user_id, project)
          team_data[index].points += Receipt.points_total(s.user_id, project)
        end
        team_totals.total_open +=     team_data[index].open
        team_totals.total_sold +=     team_data[index].sold
        team_totals.total_released += team_data[index].released
        team_totals.total_sales +=    team_data[index].sales
        team_totals.total_points +=   team_data[index].points
        index = index + 1
      end
    end

    return team_data, team_totals
  end

  # Sends back all the client data.
  def self.clients project
    Struct.new("Client", :id, :business_name, :address, :city, :state, :zipcode, :telephone, :contact_title, :contact_fname,
                         :contact_lname, :email, :status_type, :comment, :arrow, :calendar)
    clients_array = []
    index = 0

    clients = Client.where.not(status_id: 5)
    clients.each do |c|
      clients_array[index] = Struct::Client.new
      clients_array[index].id             = c.id
      clients_array[index].business_name  = c.business_name
      clients_array[index].address        = c.address
      clients_array[index].city           = c.city
      clients_array[index].state          = c.state
      clients_array[index].zipcode        = c.zipcode
      clients_array[index].telephone      = c.telephone
      clients_array[index].contact_title  = c.contact_title
      clients_array[index].contact_fname  = c.contact_fname
      clients_array[index].contact_lname  = c.contact_lname
      clients_array[index].email          = c.email
      clients_array[index].status_type    = c.status.status_type
      clients_array[index].comment        = c.comment
      clients_array[index].arrow          = Receipt.years_client_has_bought_class(c, project)[0].to_s[1..-2]
      clients_array[index].calendar       = Receipt.years_client_has_bought_class(c, project)[1].to_s[1..-2]  
      index = index + 1
    end

    return clients_array
  end

  # Calculates all the activity information and totals.
  def self.activities project, section
    Struct.new("Activity", :student_id, :manager_id, :time_of_activity, :first_name, :last_name, :section, :team_leader,
                           :company, :activity, :comments,  :points_earned, :cumulative_points_earned_on_client)

    Struct.new("Activity_Totals", :points_earned, :cumulative_points_earned_on_client)  

    activity_totals = Struct::Activity_Totals.new
    activity_totals.points_earned = 0
    activity_totals.cumulative_points_earned_on_client = 0
    activities = []                     
    index = 0
    all_current_activities = Action.all_actions_in_project(project, section)

    all_current_activities.each do |a|
      total_points = 0
      activities[index] = Struct::Activity.new
      activities[index].student_id = Receipt.find(a.receipt_id).user_id
      # activities[index].manager_id = User.get_manager_name((r.user_id), project).id  << Add this when ready for it
      activities[index].time_of_activity = a.user_action_time
      activities[index].first_name = User.find(Receipt.find(a.receipt_id).user_id).first_name
      activities[index].last_name = User.find(Receipt.find(a.receipt_id).user_id).last_name
      activities[index].section = Member.get_section_number(Receipt.find(a.receipt_id).user_id, project)
      activities[index].team_leader = User.get_manager_name((Receipt.find(a.receipt_id).user_id), project)
      activities[index].company = Client.find(Ticket.find(Receipt.find(a.receipt_id).ticket_id).client_id).business_name
      activities[index].activity = ActionType.find(a.action_type_id).name
      activities[index].points_earned = a.points_earned
      activity_totals.points_earned += a.points_earned
      all_actions_for_receipt = Action.find_all_by_receipt_id(Receipt.find(a.receipt_id))
      for i in 0..Action.where(receipt_id: a.receipt_id).all.count-1
        total_points += all_actions_for_receipt[i].points_earned
      end
      activities[index].cumulative_points_earned_on_client = total_points
      activity_totals.cumulative_points_earned_on_client += total_points
      activities[index].comments = a.comment
      index = index + 1
    end

    return activities, activity_totals
  end

  # Calculates all the bonus information and totals.
  def self.bonus project, section
    Struct.new("BonusData", :id, :first_name, :last_name, :student_id, :team_name, :created_date, :points, :comment, :section_number)

    bonuses = []

    all_bonuses = Bonus.where(project_id: project, user_id: Member.where(section_number: section).pluck(:user_id))

    i = 0
    bonus_total_points = all_bonuses.sum(:points)
    all_bonuses.each do |b|
      bonuses[i] = Struct::BonusData.new
      bonuses[i].id = b.id
      bonuses[i].created_date = b.created_at
      bonuses[i].points = b.points
      bonuses[i].comment = b.comment
      bonuses[i].first_name = User.find(b.user_id).first_name
      bonuses[i].last_name = User.find(b.user_id).last_name
      bonuses[i].student_id = User.find(b.user_id).school_id
      bonuses[i].team_name = Member.get_manager_name(Member.find_by(user_id: b.user_id, project_id: b.project_id))
      bonuses[i].section_number = Member.find_by(user_id: b.user_id, project_id: b.project_id).section_number
      i = i + 1
    end

    return bonuses, bonus_total_points
  end

  # Calculates all the end of semester information and totals.
  def self.end_of_semester_data project, section
    Struct.new("EndData", :date, :company, :address, :city, :state, :zip, :contact, :telephone, :arrow,
                          :calendar, :page_size, :sales, :first_name, :last_name, :team, :payment, :ad_status, :comments)

    end_sale_total = 0 
    end_data = []                     
    index = 0
    sold_receipts = Receipt.all_sold_clients_in_section(project)

    sold_receipts.each do |a|
      end_data[index]             = Struct::EndData.new
      end_data[index].date        = Action.find_by(action_type_id: [3, 4], receipt_id: a.id).user_action_time
      end_data[index].company     = Client.find(Ticket.find(a.ticket_id).client_id).business_name
      end_data[index].address     = Client.find(Ticket.find(a.ticket_id).client_id).address
      end_data[index].city        = Client.find(Ticket.find(a.ticket_id).client_id).city
      end_data[index].state       = Client.find(Ticket.find(a.ticket_id).client_id).state
      end_data[index].zip         = Client.find(Ticket.find(a.ticket_id).client_id).zipcode
      end_data[index].contact     = Client.find(Ticket.find(a.ticket_id).client_id).full_name
      end_data[index].telephone   = Client.find(Ticket.find(a.ticket_id).client_id).telephone
      end_data[index].arrow       = Receipt.years_client_has_bought_class(Client.find(Ticket.find(a.ticket_id).client_id), project)[0].to_s[1..-2]
      end_data[index].calendar    = Receipt.years_client_has_bought_class(Client.find(Ticket.find(a.ticket_id).client_id), project)[1].to_s[1..-2]   
      end_data[index].page_size   = a.page_size
      end_data[index].sales       = a.sale_value
      end_data[index].first_name  = User.find(a.user_id).first_name
      end_data[index].last_name   = User.find(a.user_id).last_name
      end_data[index].team        = User.get_manager_name(a.user_id, project)
      end_data[index].payment     = a.payment_type
      end_data[index].ad_status   = ActionType.find(Action.find_by(receipt_id: a.id, action_type_id: [3,4]).action_type_id).name 
      end_sale_total += a.sale_value
      index = index + 1
    end

    return end_data, end_sale_total
  end
end