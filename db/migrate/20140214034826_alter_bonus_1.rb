class AlterBonus1 < ActiveRecord::Migration
  def change
    change_column :bonus, :points, :integer, :null => false, :default => 0
    change_column :bonus, :project_id, :integer, :null => false
    change_column :bonus, :user_id, :integer, :null => false
    add_index :bonus, :project_id
    add_index :bonus, :user_id
  end
end
