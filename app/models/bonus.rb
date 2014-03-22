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

end