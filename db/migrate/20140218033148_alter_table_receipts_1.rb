class AlterTableReceipts1 < ActiveRecord::Migration
  def change
    change_column :receipts, :ticket_id, :integer, :null => false
    change_column :receipts, :user_id, :integer, :null => false
    change_column :receipts, :made_contact, :boolean, :null => false, :default => false
    change_column :receipts, :made_presentation, :boolean, :null => false, :default => false
    change_column :receipts, :made_sale, :boolean, :null => false, :default => false
    add_index :receipts, [:ticket_id, :user_id], :unique => true
    add_index :receipts, :ticket_id
    add_index :receipts, :user_id
  end
end
