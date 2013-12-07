class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members
  has_many   :semesters

  validates :year, presence: true, length: {
    minimum: 4, maximum: 4,
    message: 'is the wrong length'
  }
end
