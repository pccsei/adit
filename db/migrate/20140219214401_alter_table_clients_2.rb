class AlterTableClients2 < ActiveRecord::Migration
  def change
  	add_index :clients, [:business_name, :status_id], :unique => true
  end
end
