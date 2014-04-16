class AddAvailableBack < ActiveRecord::Migration
  def change
     add_column :users, :available, :integer
  end
end
