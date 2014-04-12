class RemoveAvailabilityColumn < ActiveRecord::Migration
  def change
     remove_column :users, :available
  end
end
