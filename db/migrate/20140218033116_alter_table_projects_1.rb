class AlterTableProjects1 < ActiveRecord::Migration
  def change
    change_column :projects, :year, :integer, :null => false
    change_column :projects, :semester, :string, :null => false
    change_column :projects, :tickets_open_time, :datetime, :null => false
    change_column :projects, :tickets_close_time, :datetime, :null => false
    change_column :projects, :max_clients, :integer, :null => false, :default => 5
    change_column :projects, :max_high_priority_clients, :integer, :null => false, :default => 0
    change_column :projects, :max_low_priority_clients, :integer, :null => false, :default => 0
    change_column :projects, :max_medium_priority_clients, :integer, :null => false, :default => 0
    change_column :projects, :use_max_clients, :boolean, :null => false, :default => false
    change_column :projects, :project_type_id, :integer, :null => false
    change_column :projects, :is_active, :boolean, :null => false, :default => true
    add_index :projects, [:year, :project_type_id, :semester], :unique => true
    add_index :projects, :project_type_id
  end
end
