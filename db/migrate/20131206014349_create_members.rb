class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :section_number
      t.boolean :is_enabled

      t.timestamps
    end

     create_table :members_users, id: false do |t|
       t.belongs_to :members
       t.belongs_to :users
     end
   end
end
