class RemoveBusinessNameIndex < ActiveRecord::Migration
  def change
    remove_index :clients, :business_name
  end
end
