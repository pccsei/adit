class FixUsers < ActiveRecord::Migration
  def change 
    remove_column :users, :name, :string
    add_column :users, :first_name, :string, :limit => 30
    add_column :users, :last_name, :string, :limit => 30
  end
end
