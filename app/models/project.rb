class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members
  has_many   :semesters

# Validates the year text field
  validates :year, presence: true, length: {
    minimum: 4, maximum: 4,
    message: 'is the wrong length.'
  }, format: {
    with: /(20)\d{2}/,
    message: 'is the wrong time period.'
  }
  
# Validates the project start and end times  
  validates :project_start, presence: true, uniqueness: true
  validates :project_end, presence: true
  validate :start_before_end
  
# Validates the max total clients option  
  validates :max_clients, length: {
    minimum: 1, maximum: 1,
    message: 'is the wrong length.  Needs to be one digit long.'
  }, numericality: { greater_than: 0 }, unless: Proc.new { |project| project.use_max_clients == false }
  
# Validates the max seperate clients option
  validates :max_green_clients, :max_yellow_clients, :max_white_clients, length: {
    minimum: 1, maximum: 1,
    message: 'is the wrong length.  Needs to be one digit long.'
  }, numericality: { greater_than_or_equal_to: 0 }, unless: Proc.new { |project| project.use_max_clients == true }
  
# Custom method to make sure the start date is before the end date  
  def start_before_end
    errors.add(:project_start, "must be before project end") unless
      self.project_start < self.project_end
  end
  
end
