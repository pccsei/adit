class RemoveColumnFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :priority, :string
  end
end
