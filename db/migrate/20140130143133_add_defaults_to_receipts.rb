class AddDefaultsToReceipts < ActiveRecord::Migration
  def change
    change_column :receipts, :made_contact, :boolean, :default => false
    change_column :receipts, :made_presentation, :boolean, :default => false
    change_column :receipts, :made_sale, :boolean, :default => false
    change_column :receipts, :ticket_id, :integer, :null => false
    change_column :receipts, :user_id, :integer, :null => false
  end
end
