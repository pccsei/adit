class AlterTablePriorities1 < ActiveRecord::Migration
  def change
    change_column :priorities, :name, :string, :null => false
    add_index :priorities, :name, :unique => true
  end
end
