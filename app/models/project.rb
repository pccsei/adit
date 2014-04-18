class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members

# Validates the year field
  validates :year, presence: true, uniqueness: { scope: :semester, message: "can only have one active project per semester of each year."}
  
# Validates the ticket open and close times  
  validates :tickets_open_time, presence: true, uniqueness: true
  validates :tickets_close_time, presence: true
  validate :start_before_end
  validate :current_selected_year
  validate :current_semester
  
# Validates the max total clients option  
  validates :max_clients, length: {
    minimum: 1,
    message: 'needs to be at least 1 digit long.'
  }
  #validate :greater_than_max
  
# Validates the max high priority clients option
  validates :max_high_priority_clients, length: {
    minimum: 1,
    message: 'needs to be at least 1 digit long.'
  } #numericality: { greater_than_or_equal_to: 1, :if => lambda { |project| (project.max_medium_priority_clients == 0 && project.max_low_priority_clients == 0) },
                 #    unless: Proc.new { |project| project.max_high_priority_clients == -1 } }
  
# Validates the max medium priority clients option
  validates :max_medium_priority_clients, length: {
    minimum: 1,
    message: 'needs to be at least 1 digit long.'
  } #numericality: { greater_than_or_equal_to: 1, :if => lambda { |project| (project.max_high_priority_clients == 0 && project.max_low_priority_clients == 0) },
                  #   unless: Proc.new { |project| project.max_medium_priority_clients == -1 } }

# Validates the max low priority clients option
  validates :max_low_priority_clients, length: {
    minimum: 1,
    message: 'needs to be at least 1 digit long.'
  } #numericality: { greater_than_or_equal_to: 1, :if => lambda { |project| (project.max_high_priority_clients == 0 && project.max_medium_priority_clients == 0) },
                 #    unless: Proc.new { |project| project.max_low_priority_clients == -1 } }

# Custom method to make sure the open date is before the close date  
  def start_before_end
    if(tickets_open_time && tickets_close_time)
      errors.add(:tickets_open_time, 'needs to start before the project end time.') unless
        self.tickets_open_time < self.tickets_close_time
    end
  end
  
# Custom method to make sure the selected year is within the ticket open time year
  def current_selected_year
    if(tickets_open_time)
      errors.add(:tickets_open_time, 'needs to be in the year you selected above.') unless
        self.tickets_open_time.year == self.year
      errors.add(:tickets_close_time, 'needs to be in the year you selected above.') unless
        self.tickets_close_time.year == self.year
    end
  end

# Custom method to make sure the ticket open and close time months are in the range of either a Fall or Spring semester
  def current_semester
    if(tickets_open_time && tickets_close_time)
      if(semester == 'Fall')
        errors.add(:tickets_open_time, 'needs to match the semester above (Fall).') unless
          self.tickets_open_time.month.between?(9,12)
        errors.add(:tickets_close_time, 'needs to match the semester above (Fall).') unless
          self.tickets_close_time.month.between?(9,12)
      else
        errors.add(:tickets_open_time, 'needs to match the semester above (Spring).') unless
          self.tickets_open_time.month.between?(1,5)
        errors.add(:tickets_close_time, 'needs to match the semester above (Spring).') unless
          self.tickets_close_time.month.between?(1,5)
      end
    end
  end
  
# Custom method to make sure the teacher does not allow restrictions lower than the max clients
  def greater_than_max
    if(max_clients >= 1 && max_high_priority_clients >= 0 && max_medium_priority_clients >= 0 && max_low_priority_clients >= 0)
      total_clients = (max_high_priority_clients + max_medium_priority_clients + max_low_priority_clients)
      errors.add(:max_clients, 'needs to be less than or equal to the combined total of high, medium, and low priority clients.') unless
        max_clients <= total_clients
    end
  end

# Teach assigns clients to the student
  def self.is_specific(pid) 
    p = Project.find(pid)
    
    (p.max_high_priority_clients   == 0 &&
     p.max_medium_priority_clients == 0 &&
     p.max_low_priority_clients    == 0)    
  end

  # Convert everything for the specified project into excel
  def self.all_to_excel project, current_user
    return Report.sales(project, "all")[0], Report.sales(project, "all")[1], Report.student_summary(project, "all", current_user)[0], 
           Report.student_summary(project, "all", current_user)[1], Report.team_summary(project, "all")[0], Report.team_summary(project, "all")[1],
           Report.clients(project), Report.activities(project, "all")[0], Report.activities(project, "all")[1], Report.bonus(project, "all")[0], 
           Report.bonus(project, "all")[1], Report.end_of_semester_data(project, "all")[0], Report.end_of_semester_data(project, "all")[1],
           User.get_student_info(project, "all", 3), User.all_teachers, User.current_teachers(project)
  end

  def self.non_archived
    where('year > ?', 2013)
  end
  
  def self.current
    find_by(is_active: true)
  end 
  
  def self.current_for_user(uid)
    
  end
    
  def self.archived
    where('year < ? and is_active = ?', 2014, false)
  end
    
end
