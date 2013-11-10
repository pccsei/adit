class Bonus < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
