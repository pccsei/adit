class Project < ActiveRecord::Base
  has_many :tickets
  has_many :bonuses
end
