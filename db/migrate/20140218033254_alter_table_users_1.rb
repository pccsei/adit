class AlterTableUsers1 < ActiveRecord::Migration
  def change
    change_column :users, :school_id, :string, :null => false
    change_column :users, :role, :integer, :null => false
    change_column :users, :help, :boolean, :null => false, :default => false
  end
end
