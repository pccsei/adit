class AddColumnsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :project_id, :integer
    add_column :tickets, :client_id, :integer
    add_column :tickets, :user_id, :integer
    add_column :tickets, :priority_id, :integer
  end
end
