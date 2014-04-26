class Bonuses < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :bonus_type
  
  
  
  
  
  
  
  # Old code - use for refences while creating new bonus features
=begin
  
  def self.delete_bonus bonus, all
    if all.to_i == 1
      Bonus.destroy_all(created_at: bonus.created_at)
    else
      Bonus.destroy(bonus)
    end
  end

  # Retrieve the total bonuses assigned to a student
  def self.get_student_bonus_total(student_id, proj_id)
    Bonus.where(user_id: student_id, project_id: proj_id).sum(:points)
  end
  # Make a change to the bonus
  def self.edit_bonus bonus, new_points, new_comment
    bonuses = Bonus.where(created_at: bonus.created_at)
    # Assign 0 points if nothing was specified.
    if new_points == ""
      new_points = 0
    end

    bonuses.each do |b|
      b.points = new_points;
      b.comment = new_comment;
      b.save
    end
  end
=end
end