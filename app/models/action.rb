class Action < ActiveRecord::Base
  belongs_to :action_type
  belongs_to :receipt
  has_paper_trail
  
  def self.create_action (price, page, payment_type, presentation, sale, action, receipt)
    action_name = action.action_type.name

    if action_name == 'First Contact'
       receipt.made_contact = true
    elsif action_name == 'Presentation'
      receipt.made_presentation = true
    elsif (action_name == 'New Sale' || action_name == 'Old Sale')
      receipt.made_sale    = true
      receipt.sale_value   = price
      receipt.page_size    = page
      receipt.payment_type = payment_type
    end

    if presentation
      new_action                  = Action.new
      new_action.user_action_time = action.user_action_time
      new_action.comment          = action.comment
      new_action.action_type_id   = (ActionType.find_by(name: 'Presentation')).id
      new_action.receipt_id       = action.receipt_id
      new_action.points_earned    = (ActionType.find_by(name: 'Presentation')).point_value
      receipt.made_presentation   = true
    end

    if sale
      priority = receipt.ticket.priority.name
      next_action = Action.new
      if priority == 'high'
        next_action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
        next_action.points_earned  = (ActionType.find_by(name: 'Old Sale')).point_value
      else
        next_action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
        next_action.points_earned  = (ActionType.find_by(name: 'New Sale')).point_value
      end
      next_action.user_action_time = action.user_action_time
      next_action.comment          = action.comment
      next_action.receipt_id       = action.receipt_id
      receipt.made_sale            = true
      receipt.sale_value           = price
      receipt.page_size            = page
      receipt.payment_type         = payment_type
    end
    return action, receipt, next_action, new_action
  end

  def self.delete_activity(action, receipt)
    if action.action_type.name == 'Presentation'
      action.receipt.made_presentation = false
      receipt.made_presentation = false
    elsif action.action_type.name == 'First Contact'
      action.receipt.made_contact = false
      receipt.made_contact = false
    elsif (action.action_type.name == 'New Sale' || action.action_type.name == 'Old Sale')
      action.receipt.made_sale = false
      action.receipt.sale_value = 0
      action.receipt.page_size = 0
      action.receipt.payment_type = nil
      receipt.made_sale = false
      receipt.sale_value   = nil
      receipt.page_size    = nil
      receipt.payment_type = nil
    end
    action.receipt.save
    action.destroy
    receipt.save
  end

  def self.new_action(action, receipt, action_received)
    if action_received == 'Sale'
      if receipt.ticket.priority.name == 'high'
        action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
        action.points_earned = (ActionType.find_by(name: 'Old Sale')).point_value
      else
        action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
        action.points_earned = (ActionType.find_by(name: 'New Sale')).point_value
      end
    else
      action.action_type_id = (ActionType.find_by(name: action_received)).id
      action.points_earned = (ActionType.find_by(name: action_received)).point_value
    end
  end

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
