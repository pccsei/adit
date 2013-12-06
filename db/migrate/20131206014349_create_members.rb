class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :section_number
      t.boolean :is_enabled

      t.timestamps
    end
    
    add_reference :members, :user, index: true

  end
end
