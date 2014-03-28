class Bonus < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  def self.delete_bonus bonus, all
  	if all.to_i == 1
  		Bonus.destroy_all(created_at: bonus.created_at)
  	else
  		Bonus.destroy(bonus)
  	end
  end

  def self.edit_bonus bonus, new_points, new_comment
  	bonuses = Bonus.where(created_at: bonus.created_at)
  	if new_points == ""
  		new_points = 0
  	end

  	bonuses.each do |b|
	  b.points = new_points;
	  b.comment = new_comment;
	  b.save
	end
  end
end