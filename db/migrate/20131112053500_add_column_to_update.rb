class AddColumnToUpdate < ActiveRecord::Migration
  def change
    add_column :updates, :receipt_id, :integer
  end
end
