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
end
