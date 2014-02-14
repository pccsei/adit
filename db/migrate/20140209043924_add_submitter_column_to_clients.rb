class AddSubmitterColumnToClients < ActiveRecord::Migration
  def change
    add_column :clients, :submitter, :string
  end
end
