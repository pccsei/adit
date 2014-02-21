class RemoveAnotherIndexFromClients < ActiveRecord::Migration
  def change
    remove_index :clients, name: :index_clients_on_business_name_and_status_id
  end
end
