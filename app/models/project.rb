class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members
  has_many   :semesters

# Validates the year text field
  validates :year, presence: true, length: {
    minimum: 4, maximum: 4,
    message: 'is the wrong length.  Needs to be only four digits long.'
  }, numericality: { greater_than_or_equal_to: 2014}
  
# Validates the tickets open and close times  
  validates :tickets_open_time, presence: true, uniqueness: true
  validates :tickets_close_time, presence: true
  validate :start_before_end
  
# Validates the max total clients option  
  validates :max_clients, length: {
    minimum: 1,
    message: 'is the wrong length.  Needs to be one digit long.'
  }, numericality: { greater_than: 0 }, unless: Proc.new { |project| project.use_max_clients == false }
  
# Validates the max hight priority clients option
  validates :max_high_priority_clients, length: {
    minimum: 1,
    message: 'is the wrong length.  Needs to be at least one digit long.'
  }, numericality: { greater_than_or_equal_to: 1, :if => lambda { |project| (project.max_medium_priority_clients == 0 && project.max_low_priority_clients == 0) } }, 
      unless: Proc.new { |project| project.use_max_clients == true }
  
# Validates the max medium priority clients option
  validates :max_medium_priority_clients, length: {
    minimum: 1,
    message: 'is the wrong length.  Needs to be at least one digit long.'
  }, numericality: { greater_than_or_equal_to: 1, :if => lambda { |project| (project.max_high_priority_clients == 0 && project.max_low_priority_clients == 0) } }, 
      unless: Proc.new { |project| project.use_max_clients == true }

# Validates the max low priority clients option
  validates :max_low_priority_clients, length: {
    minimum: 1,
    message: 'is the wrong length.  Needs to be at least one digit long.'
  }, numericality: { greater_than_or_equal_to: 1, :if => lambda { |project| (project.max_high_priority_clients == 0 && project.max_medium_priority_clients == 0) } }, 
      unless: Proc.new { |project| project.use_max_clients == true }  
# Custom method to make sure the start date is before the end date  
  def start_before_end
    if(tickets_open_time && tickets_close_time)
    errors.add(:tickets_open_time, "must be before project end.") unless
      self.tickets_open_time < self.tickets_close_time
    end
  end
  
  def self.non_archived
    where("year > ?", 2013)
  end
  
  def self.current
    active = 1
    where("is_active = ? ", active)
  end 
    
  def self.archived
    inactive = 0
    year_project_was_created = 2013 # Removes dummy projects used for creating ticket priority for the first few years  
    where("year > ? and is_active = ?", year_project_was_created, inactive)
  end
    
end
