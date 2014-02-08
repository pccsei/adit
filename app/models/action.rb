class Action < ActiveRecord::Base
  belongs_to :action_type
  belongs_to :receipt
  
  def self.get_last_activity(student_id, project)
    receipts = Receipt.where("user_id = ?", student_id)
    last = "2100-JAN-1 00:00:00"
    receipts.each do |r|
      r.actions.each do |a|
        if a.user_action_time < last
          last = a.user_action_time
        end
      end
    end

    if last == "2100-JAN-1 00:00:00"
      last = nil
    else
      last
    end
  end

  def Action.all_actions_in_project(project)
    i = 0
    tickets = Ticket.where("project_id = ?", project)
    receipts = []
    actions = []
    tickets.each do |t|
      receipts[i] = Receipt.where("ticket_id = ?", t.id)
      i = i + 1
    end
    for i in 0..receipts.count-1
      if Action.find_by(receipt_id: receipts[i][0])
        actions[i] = Action.find_by(receipt_id: receipts[i][0]).id
      end 
    end
    actions = Action.find(actions)
  end
end
