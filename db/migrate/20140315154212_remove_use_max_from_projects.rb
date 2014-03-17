class RemoveUseMaxFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :use_max_clients, :boolean
  end
end
