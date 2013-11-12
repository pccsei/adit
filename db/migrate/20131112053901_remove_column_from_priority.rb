class RemoveColumnFromPriority < ActiveRecord::Migration
  def change
    remove_column :priorities, :level, :string
  end
end
