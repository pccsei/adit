class AddHelpColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :help, :boolean
  end
end
