class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :school_id, :string
    add_column :users, :role, :int
    add_column :users, :section, :int
    add_column :users, :parent_id, :string
    add_column :users, :email, :string
    add_column :users, :extension, :int
  end
end
