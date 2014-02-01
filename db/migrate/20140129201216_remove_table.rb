class RemoveTable < ActiveRecord::Migration
  def change
    drop_table :updates
  end
end
