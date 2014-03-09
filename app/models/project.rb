class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members

# Validates the year field
  validates :year, presence: true#, uniqueness: { #scope: :semester, message: "can only be one active project per semester of each year."}
  
# Validates the ticket open and close times  
  validates :tickets_open_time, presence: true, uniqueness: true
  validates :tickets_close_time, presence: true
  validate :start_before_end
  #validate :current_selected_year
 # validate :current_semester
  
# Validates the max total clients option  
  validates :max_clients, length: {
    minimum: 1,
    message: 'is the wrong length.  Needs to be one digit long.'
  }, numericality: { greater_than: 0 }, unless: Proc.new { |project| project.use_max_clients == false }
  
# Validates the max high priority clients option
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

# Custom method to make sure the open date is before the close date  
  def start_before_end
    if(tickets_open_time && tickets_close_time)
      errors.add(:tickets_open_time, 'must be before project end.') unless
        self.tickets_open_time < self.tickets_close_time
    end
  end
  
# Custom method to make sure the selected year is within the ticket open time year
  def current_selected_year
    if(tickets_open_time)
      errors.add(:tickets_open_time, 'must be in the year you selected above.') unless
        self.tickets_open_time.year == self.year
      errors.add(:tickets_close_time, 'must be in the year you selected above.') unless
        self.tickets_close_time.year == self.year
    end
  end

# Custom method to make sure the ticket open and close time months are in the range of either a Fall or Spring semester
  def current_semester
    if(tickets_open_time && tickets_close_time)
      if(semester == 'Fall')
        errors.add(:tickets_open_time, 'must be in the Fall semester.') unless
          self.tickets_open_time.month.between?(9,12)
        errors.add(:tickets_close_time, 'must be in the Fall semester.') unless
          self.tickets_close_time.month.between?(9,12)
      else
        errors.add(:tickets_open_time, 'must be in the Spring semester.') unless
          self.tickets_open_time.month.between?(1,5)
        errors.add(:tickets_close_time, 'must be in the Spring semester.') unless
          self.tickets_close_time.month.between?(1,5)
      end
    end
  end

  def self.non_archived
    where('year > ?', 2013)
  end
  
  def self.current
    where('is_active = ?', true)
  end 
    
  def self.archived
    where('year < ? and is_active = ?', 2014, false)
  end
    
end
