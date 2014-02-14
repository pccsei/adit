class AlterClients1 < ActiveRecord::Migration
  def change
    change_column :clients, :business_name, :string, :null => false
    add_index :clients, :business_name, :unique => true
  end
end
