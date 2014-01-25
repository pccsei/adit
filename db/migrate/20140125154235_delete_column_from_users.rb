class DeleteColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :parent_id, :integer
    add_column :members, :parent_id, :integer
  end
end
