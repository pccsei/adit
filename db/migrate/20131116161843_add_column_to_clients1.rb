class AddColumnToClients1 < ActiveRecord::Migration
  def change
    add_column :clients, :status, :integer, :limit => 2
  end
end
