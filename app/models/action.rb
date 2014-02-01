class Action < ActiveRecord::Base
  belongs_to :action_type
  belongs_to :receipt
end
