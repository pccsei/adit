class AlterMembers1 < ActiveRecord::Migration
  def change
    change_column :members, :section_number, :integer, :null => false
    change_column :members, :is_enabled, :boolean, :default => true, :null => false
    change_column :members, :user_id, :integer, :null => false
    change_column :members, :project_id, :integer, :null => false
    change_column :members, :parent_id, :integer
    add_index :members, :parent_id
  end
end
