class Bonuses < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :bonus_type
  
  # Retrieve the total bonuses assigned to a student
  def self.get_student_bonus_total(student_id, proj_id)
    Bonuses.where(user_id: student_id, project_id: proj_id).sum(:points_earned)
  end
  
  def self.get_bonuses(student_id, proj_id)
    Bonuses.where(user_id: student_id, project_id: proj_id)
  end

end