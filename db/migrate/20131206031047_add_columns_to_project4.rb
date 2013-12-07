class AddColumnsToProject4 < ActiveRecord::Migration
  def change
    add_column :projects, :is_active, :boolean
    add_column :projects, :ticket_close_time, :datetime
  end
end
