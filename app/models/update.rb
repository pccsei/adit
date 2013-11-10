class Update < ActiveRecord::Base
  belongs_to :receipt
  has_many   :actions
end

