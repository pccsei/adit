class AlterActions1 < ActiveRecord::Migration
  def change
    change_column :actions, :points_earned, :integer, :null => false
    change_column :actions, :user_action_time, :datetime, :null => false, :default => Time.now
    change_column :actions, :action_type_id, :integer, :null => false
    change_column :actions, :receipt_id, :integer, :null => false
  end
end
