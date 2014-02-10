class ChangeProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :project_start, :tickets_open_time
    rename_column :projects, :project_end, :tickets_close_time
    rename_column :projects, :max_green_clients, :max_high_priority_clients
    rename_column :projects, :max_white_clients, :max_low_priority_clients
    rename_column :projects, :max_yellow_clients, :max_medium_priority_clients
  end
end
