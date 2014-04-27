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
  def self.update_bonus bonus_type_id, current_project_id, bonus_type_params
    update_bonus = BonusType.find(bonus_type_id)
    update_bonus.name = bonus_type_params[:name]
    update_bonus.point_value = bonus_type_params[:point_value]
    Bonuses.where(bonus_type_id: update_bonus.id, project_id: current_project_id).each do |b|
      b.points_earned = bonus_type_params[:point_value]
      b.save
    end
    update_bonus.save
  end
end