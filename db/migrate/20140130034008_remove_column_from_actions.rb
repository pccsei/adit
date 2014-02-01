class RemoveColumnFromActions < ActiveRecord::Migration
  def change
    remove_column :actions, :update_id, :integer
  end
end
