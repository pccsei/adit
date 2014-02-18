class AlterTableStatuses1 < ActiveRecord::Migration
  def change
    change_column :statuses, :status_type, :string, :null => false
    add_index :statuses, :status_type, :unique => true
  end
end
