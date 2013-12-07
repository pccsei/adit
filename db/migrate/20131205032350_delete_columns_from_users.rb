class DeleteColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :clients, :status, :integer
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string
    remove_column :users, :current_sign_in_at, :datetime
  end
end
