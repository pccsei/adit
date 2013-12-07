class RemoveColumnFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :is_current_project, :boolean
  end
end
