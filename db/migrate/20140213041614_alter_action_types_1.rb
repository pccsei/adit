class AlterActionTypes1 < ActiveRecord::Migration
  def change
    change_column :action_types, :name, :string, :null => false
    change_column :action_types, :role, :integer, :null => false
    change_column :action_types, :point_value, :integer, :null => false
  end
end
