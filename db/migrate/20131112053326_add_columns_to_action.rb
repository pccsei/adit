class AddColumnsToAction < ActiveRecord::Migration
  def change
    add_column :actions, :update_id, :integer
    add_column :actions, :action_type_id, :integer
    add_column :actions, :receipt_id, :integer
  end
end
