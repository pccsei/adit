class RemoveDuplicateStatusTable < ActiveRecord::Migration
  def change
    drop_table :status_tables
  end
end
