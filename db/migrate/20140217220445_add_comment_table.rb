class AddCommentTable < ActiveRecord::Migration
  def change
    create_table :comments do |c|
      c.text :body
    end  
      add_reference :comments, :ticket, index: true 
      add_reference :comments, :user, index: true 
  end
end
