class AddMoreColumnsToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :sale_value, :float
    add_column :receipts, :page_size, :float
    add_column :receipts, :payment_type, :string
  end
end
