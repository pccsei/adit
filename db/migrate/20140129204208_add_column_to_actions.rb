class AddColumnToActions < ActiveRecord::Migration
  def change
    add_column :actions, :comment, :text
  end
end
