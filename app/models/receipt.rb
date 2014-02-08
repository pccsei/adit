class Receipt < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many   :actions
  
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
  
  def self.open_clients(student_id, project)
    receipts = Receipt.where("user_id = ? AND made_sale = ?", student_id, false)
    remove_receipts = []
    
    for index in 0..(receipts.size - 1)
      ticket = receipts[index].ticket
      if ticket.project_id != project.id || ticket.user_id != student_id
        remove_receipts.push(receipts[index])
      end
    end
    return receipts - remove_receipts
  end
  
  def self.sold_clients(student_id, project)
    receipts = Receipt.where("user_id = ? AND made_sale = ?", student_id, true)
    remove_receipts = []
    
    for index in 0..(receipts.size - 1)
      ticket = receipts[index].ticket
      if ticket.project_id != project.id || ticket.user_id != student_id
        remove_receipts.push(receipts[index])
      end
    end
    return receipts - remove_receipts
  end
  
  def self.released_clients(student_id, project)
    receipts = Receipt.where("user_id = ?", student_id)
    remove_receipts = []
    
    for index in 0..(receipts.size - 1)
      ticket = receipts[index].ticket
      if ticket.project_id != project.id || ticket.user_id == student_id
        remove_receipts.push(receipts[index])
      end
    end
    return receipts - remove_receipts
  end
  
  def self.sales_total(student_id, project)
    sales = self.sold_clients(student_id, project)
    money = 0
    sales.each do |s|
      money += s.sale_value
    end
    return money
  end
  
  def self.points_total(student_id, project)
    tickets = Ticket.where("user_id = ? AND project_id = ?", student_id, project.id)
    stu_receipts = Receipt.none
    tickets.each do |t|
      stu_receipts << t.receipts
    end
    
    points = 0
    stu_receipts.each do |r|
      r.actions.each do |a|
        a.action_types.each do |t|
          points += t.point_value
        end
      end
    end
    
    return points
  end
    
 
end

