class Add3ColumnsToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :made_contact, :boolean
    add_column :receipts, :made_presentation, :boolean
    add_column :receipts, :made_sale, :boolean
  end
end
