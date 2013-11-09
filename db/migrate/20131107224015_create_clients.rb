class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :id
      t.string :business_name
      t.string :address
      t.integer :priority
      t.string :email
      t.string :contact_name
      t.string :telephone
      t.text :comment

      t.timestamps
    end
  end
end
