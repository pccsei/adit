class AddColumnToProjects3 < ActiveRecord::Migration
  def change
    add_column :projects, :is_current_project, :boolean
  end
end
