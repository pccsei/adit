class AlterActions2 < ActiveRecord::Migration
  def change
    change_column :actions, :user_action_time, :datetime, :default => nil
    add_index :actions, :action_type_id
    add_index :actions, :receipt_id
  end
end
