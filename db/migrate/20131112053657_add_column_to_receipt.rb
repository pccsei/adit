class AddColumnToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :ticket_id, :integer
    add_column :receipts, :user_id, :integer
  end
end
