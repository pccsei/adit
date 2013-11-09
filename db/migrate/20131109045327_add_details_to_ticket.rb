class AddDetailsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :payment_type, :string
    add_column :tickets, :attachment, :binary
  end
end
