class RemoveUselessColumns < ActiveRecord::Migration
  def change
    remove_column :statuses, :status_enabled, :boolean
    remove_column :clients, :website, :string
    remove_column :clients, :email, :string

    drop_table :updates
  end
end
