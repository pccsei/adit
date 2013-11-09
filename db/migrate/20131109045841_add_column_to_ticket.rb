class AddColumnToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :attachment_name, :string
  end
end
