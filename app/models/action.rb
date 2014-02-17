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

  def Action.all_actions_in_project(project, section_number)
    if section_number != "all"
      Action.where(receipt_id: Receipt.where(ticket_id: Ticket.where(project_id: project))) & Action.where(receipt_id: Receipt.where(user_id: User.where(id: Member.where(section_number: section_number).pluck(:user_id))))
    else
      Action.where(receipt_id: Receipt.where(ticket_id: Ticket.where(project_id: project)))
    end
  end
end
