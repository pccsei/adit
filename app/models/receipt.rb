class Receipt < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many   :actions
  
  # def self.released_receipts
    # all :conditions => {['']}
  # end
end

