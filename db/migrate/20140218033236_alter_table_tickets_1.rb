class AlterTableTickets1 < ActiveRecord::Migration
  def change
    change_column :tickets, :project_id, :integer, :null => false
    change_column :tickets, :client_id, :integer, :null => false
    change_column :tickets, :user_id, :integer, :null => false
    change_column :tickets, :priority_id, :integer, :null => false
    add_index :tickets, [:client_id, :project_id], :unique => true
    add_index :tickets, :project_id
    add_index :tickets, :client_id
    add_index :tickets, :user_id
    add_index :tickets, :priority_id
  end
end
