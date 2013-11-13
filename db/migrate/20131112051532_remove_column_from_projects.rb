class RemoveColumnFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :project_type, :string
  end
end
