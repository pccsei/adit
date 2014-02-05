class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members
  has_many   :semesters

  validates :year, presence: true, length: {
    minimum: 4, maximum: 4,
    message: 'is the wrong length.'
  }, format: {
    with: /(20)\d{2}/,
    message: 'is the wrong time period.'
  }
  validates :project_start, presence: true, uniqueness: true
  validates :project_end, presence: true
  validates :max_clients, allow_blank: true, length: {
    minimum: 1, maximum: 1,
    message: 'is the wrong length.  Needs to be one digit long.'
  }, numericality: { greater_than: 0 }
  validates :max_green_clients, :max_yellow_clients, :max_white_clients, allow_blank: true, length: {
    minimum: 1, maximum: 1,
    message: 'is the wrong length.  Needs to be one digit long.'
  }
  
end
