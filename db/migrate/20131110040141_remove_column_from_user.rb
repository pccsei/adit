class RemoveColumnFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :extension, :string
  end
end
