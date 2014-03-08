class Receipt < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many   :actions
  has_one :client, through: :tickets
  
  
  # def self.released_receipts
    # all :conditions => {['']}
  # end
  
  # Returns all the receipts for the selected project
  def self.selected_project_receipts(project)
    
    tickets = Ticket.current_project(project.id)
    receipts = []
    
    tickets.each do |ticket|
      receipts << ticket.receipts unless ticket.receipts == nil
    end
    
    return receipts
  end
  
  # JMu changed this function
  def self.open_clients(student_id, project)
    # receipts = Receipt.where("user_id = ? AND made_sale = ?", student_id, false)
    # remove_receipts = []    
    # for index in 0..(receipts.size - 1)
    #   ticket = receipts[index].ticket
    #   if ticket.project_id != project.id || ticket.user_id != student_id
    #     remove_receipts.push(receipts[index])
    #   end
    # end
    # return receipts - remove_receipts

    Receipt.where(user_id: student_id, made_sale: false, ticket_id: Ticket.where(project_id: project), ticket_id: Ticket.where(user_id: student_id))
  end
  
  # JMu changed this function
  def self.sold_clients(student_id, project)
    # receipts = Receipt.where("user_id = ? AND made_sale = ?", student_id, true)
    # remove_receipts = []
    
    # for index in 0..(receipts.size - 1)
    #   ticket = receipts[index].ticket
    #   if ticket.project_id != project.id || ticket.user_id != student_id
    #     remove_receipts.push(receipts[index])
    #   end
    # end
    # return receipts - remove_receipts

    Receipt.where(user_id: student_id, made_sale: true, ticket_id: Ticket.where(project_id: project))
  end

  def self.all_sold_clients_in_section(project, section_number="all")
    if section_number != "all"
      Receipt.where(made_sale: true, ticket_id: Ticket.where(project_id: project.id)) & Receipt.where(user_id: User.where(id: Member.where(section_number: section_number).pluck(:user_id)))
    else
      Receipt.where(made_sale: true, ticket_id: Ticket.where(project_id: project.id))
    end

  end
 
   # JMu changed this function
  def self.released_clients(student_id, project)
    # receipts = Receipt.where("user_id = ?", student_id)
    # remove_receipts = []
    
    # for index in 0..(receipts.size - 1)
    #   ticket = receipts[index].ticket
    #   if ticket.project_id != project.id || ticket.user_id == student_id
    #     remove_receipts.push(receipts[index])
    #   end
    # end
    # return receipts - remove_receipts

    Receipt.where(user_id: student_id, ticket_id: Ticket.where(project_id: project)) - Receipt.where(user_id: student_id, ticket_id: Ticket.where(project_id: project), ticket_id: Ticket.where(user_id: student_id)) 
  end

  def self.sales_total(student_id, project)
    sales = self.sold_clients(student_id, project)
    money = 0
    sales.each do |s|
      money += s.sale_value
    end
    return money
  end
 
   # JMu changed this function 
  def self.points_total(student_id, project)
    receipts = Receipt.where(user_id: student_id, ticket_id: Ticket.where(project_id: project))
    points = 0
    # remove_receipts = []

    
    # for index in 0..(receipts.size - 1)
    #   if (receipts[index].ticket).project_id != project.id
    #     remove_receipts << receipts[index]
    #   end
    # end
    # receipts = receipts - remove_receipts
    
    for index in 0..(receipts.size - 1)
      receipts[index].actions.each do |a|
        points += a.points_earned        
      end
    end
    
    return points
  end
  
  def self.release!
    self.ticket.user_id = nil
  end
    
  def self.get_sold_receipts_for_client_up_to_project(client, project)
      client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: Project.where("semester = ? AND year < ? OR semester = ? AND year < ?", "Spring", (project.year), "Fall", (project.year - 1)).ids))
  end

  def self.years_client_has_bought_class(client, project)
      arrow =    Project.where(id: Ticket.where(id: client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: Project.where("semester = ? AND year < ? AND project_type_id = ? OR semester = ? AND year < ? AND project_type_id = ? ", "Spring", (project.year), ProjectType.find_by(name: "Arrow"),    "Fall", (project.year - 1), ProjectType.find_by(name: "Arrow"   )).ids)).pluck(:ticket_id)).pluck(:project_id)).pluck(:year)
      calendar = Project.where(id: Ticket.where(id: client.receipts.where(made_sale: true, ticket_id: client.tickets.where(project_id: Project.where("semester = ? AND year < ? AND project_type_id = ? OR semester = ? AND year < ? AND project_type_id = ? ", "Spring", (project.year), ProjectType.find_by(name: "Calendar"), "Fall", (project.year - 1), ProjectType.find_by(name: "Calendar")).ids)).pluck(:ticket_id)).pluck(:project_id)).pluck(:year)
      return arrow, calendar
  end
end

