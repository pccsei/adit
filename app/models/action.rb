class Action < ActiveRecord::Base
  belongs_to :action_type
  belongs_to :receipt
  has_paper_trail
  
  validates :user_action_time, presence: true
  validates :points_earned, presence: true
  validates :receipt_id, presence: true
  validates :action_type_id, presence: true
  
  def self.create_action (price, page, payment_type, comment, contact, presentation, sale, user_action_time, receipt)

    if contact
      contact_action                  = Action.new
      contact_action.user_action_time = user_action_time
      contact_action.comment          = comment
      contact_action.action_type_id   = (ActionType.find_by(name: 'First Contact')).id
      contact_action.receipt_id       = receipt.id
      contact_action.points_earned    = (ActionType.find_by(name: 'First Contact')).point_value
      contact_action.save
      receipt.made_contact            = true
    end
    
    if presentation
      presentation_action                  = Action.new
      presentation_action.user_action_time = user_action_time
      presentation_action.comment          = comment
      presentation_action.action_type_id   = (ActionType.find_by(name: 'Presentation')).id
      presentation_action.receipt_id       = receipt.id
      presentation_action.points_earned    = (ActionType.find_by(name: 'Presentation')).point_value
      presentation_action.save
      receipt.made_presentation            = true
    end

    if sale
      priority = receipt.ticket.priority.name
      sale_action = Action.new
      if priority == 'high'
        sale_action.action_type_id = (ActionType.find_by(name: 'Old Sale')).id
        sale_action.points_earned  = (ActionType.find_by(name: 'Old Sale')).point_value
      else
        sale_action.action_type_id = (ActionType.find_by(name: 'New Sale')).id
        sale_action.points_earned  = (ActionType.find_by(name: 'New Sale')).point_value
      end
      sale_action.user_action_time = user_action_time
      sale_action.comment          = comment
      sale_action.receipt_id       = receipt.id
      sale_action.save
      receipt.made_sale            = true
      receipt.sale_value           = price
      receipt.page_size            = page
      receipt.payment_type         = payment_type
    end
  if !contact && !presentation && !sale && comment
    if comment.present?
      comment_action                  = Action.new
      comment_action.user_action_time = user_action_time
      comment_action.points_earned    = (ActionType.find_by(name: 'Comment')).point_value
      comment_action.comment          = comment
      comment_action.action_type_id      = (ActionType.find_by(name: 'Comment')).id
      comment_action.receipt_id       = receipt.id
      comment_action.save
    else
      message                         = 'No information entered.'
    end
  end
    receipt.save
    return message
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
      receipt.made_sale = false
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
