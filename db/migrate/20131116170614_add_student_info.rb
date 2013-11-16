class AddStudentInfo < ActiveRecord::Migration
  def change
    add_column :users, :box, :integer
    add_column :users, :major, :string, :limit => 75
    add_column :users, :minor, :string, :limit => 75
    add_column :users, :classification, :string, :limit => 10
  end
end
