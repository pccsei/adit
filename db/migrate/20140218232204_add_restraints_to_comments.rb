class AddRestraintsToComments < ActiveRecord::Migration
  def change
    change_column :comments, :body, :text, :null => false
    change_column :comments, :user_id, :integer, :null => false
    change_column :comments, :ticket_id, :integer, :null => false
  end
end
