class EditTicketes < ActiveRecord::Migration
  def change
    remove_column :tickets, :sale_value, :float
    remove_column :tickets, :page_size, :float
    remove_column :tickets, :attachment, :binary
    remove_column :tickets, :attachment_name, :string
    remove_column :tickets, :payment_type, :string
  end
end
