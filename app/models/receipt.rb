class Receipt < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many   :updates
  has_many   :actions 
end

