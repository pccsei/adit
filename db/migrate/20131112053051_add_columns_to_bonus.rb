class AddColumnsToBonus < ActiveRecord::Migration
  def change
    add_column :bonus, :project_id, :integer
    add_column :bonus, :user_id, :integer
  end
end
