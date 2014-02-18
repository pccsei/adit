class AlterTableProjectTypes1 < ActiveRecord::Migration
  def change
    change_column :project_types, :name, :string, :null => false
    add_index :project_types, :name, :unique => true
  end
end
