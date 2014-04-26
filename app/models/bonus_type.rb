class BonusType < ActiveRecord::Base
  has_many :bonuses

  def name_plus_points
    "#{point_value} #{name}"
  end

  # Hide the bonus type from the teacher. 
  # Delete the bonus of those who currently have that type of bonus in the current project. 
  # Save the others that are already just being used for achieve purposes.
  def self.inactivate_bonus bonus_type_id, current_project_id
    inactive_bonus = BonusType.find(bonus_type_id)
    inactive_bonus.is_active = false
    Bonuses.where(bonus_type_id: inactive_bonus.id, project_id: current_project_id).destroy_all
    if inactive_bonus.save
      "#{inactive_bonus.name} was deleted for the current project."
    end
  end

  # Update the bonus to give all the current project users who have the bonus the new name and points.
  def self.update_bonus bonus_type_id, current_project_id, name, points
    update_bonus = BonusType.find(bonus_type_id)
    update_bonus.name = name
    update_bonus.point_value = points
    Bonuses.where(bonus_type_id: update_bonus.id, project_id: current_project_id).each do |b|
      b.points_earned = points
      b.save
    end
    update_bonus.save
  end
end