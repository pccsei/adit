class NoMoreAvailable < ActiveRecord::Migration
  def change
     remove_column :users, :available, :integer
  end
end
