class Ticket < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :priority
  belongs_to :user
  has_many   :receipts  
end
