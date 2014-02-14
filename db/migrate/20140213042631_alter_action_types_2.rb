class AlterActionTypes2 < ActiveRecord::Migration
  def change
    add_index :action_types, :name, :unique => true
  end
end
