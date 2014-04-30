class Project < ActiveRecord::Base
  belongs_to :project_type
  has_many   :tickets
  has_many   :bonuses
  has_many   :members

  # Validates the year for the project
  validates :year, presence: true, uniqueness: { scope: :semester, message: "can only have one active project per semester of each year."}
  
  # Validates the start and end times for the project  
  validates :tickets_open_time, presence: true, uniqueness: true
  validates :tickets_close_time, presence: true
  validate :start_before_end
  validate :current_selected_year
  validate :current_semester

  # Custom method to make sure the start time is before the end time  
  def start_before_end
    if(tickets_open_time && tickets_close_time)
      errors.add(:tickets_open_time, 'needs to start before the project end time.') unless
        self.tickets_open_time < self.tickets_close_time
    end
  end
  
  # Custom method to make sure the selected year is in the start time
  def current_selected_year
    if(tickets_open_time)
      errors.add(:tickets_open_time, 'needs to be in the year you selected above.') unless
        self.tickets_open_time.year == self.year
      errors.add(:tickets_close_time, 'needs to be in the year you selected above.') unless
        self.tickets_close_time.year == self.year
    end
  end

# Custom method to make sure the start and end times are within the selected semester
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

  # Teacher assigns clients to the student
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

  # Projects where Adit was being used and true sale history exists
  def self.non_archived
    where('(year > ? AND semester = ?) OR (year > ? AND semester = ?)', LAST_NON_ADIT_ARROW_YEAR, "Fall", LAST_NON_ADIT_CALENDAR_YEAR, "Spring")
  end
  
  # Projects where Adit was not being used and no true sale history exists
  def self.archived
    where('(year <= ? AND semester = ?) OR (year <= ? AND semester = ?)', LAST_NON_ADIT_ARROW_YEAR, "Fall", LAST_NON_ADIT_CALENDAR_YEAR, "Spring")
  end
  
  # The current, active project
  def self.current
    find_by(is_active: true)
  end  
    
end
