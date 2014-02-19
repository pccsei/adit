class AddEditedByColumnToClients < ActiveRecord::Migration
  def change
     add_column :clients, :parent_id, :integer
  end
end
