class FixClients < ActiveRecord::Migration
  def change
    add_column :clients, :zipcode, :integer
    add_column :clients, :contact_fname, :string, :limit => 30
    add_column :clients, :contact_lname, :string, :limit => 30
    add_column :clients, :contact_title, :string, :limit => 10
    add_column :clients, :city, :string, :limit => 30
    add_column :clients, :state, :string, :limit => 2
    remove_column :clients, :contact_name, :string
 end
end
