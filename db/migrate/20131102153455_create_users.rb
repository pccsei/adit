class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :id
      t.string :name
      t.string :school_id
      t.integer :role
      t.integer :section
      t.string :parent_id
      t.string :email
      t.string :mobile_number
      t.integer :box_number
      t.string :room_number
      t.integer :power_token

      t.timestamps
    end
  end
end
