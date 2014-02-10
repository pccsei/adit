class AdjustProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :ticket_close_time, :datetime
  end
end
