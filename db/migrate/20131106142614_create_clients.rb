class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :business_name
      t.text :address
      t.string :email
      t.string :website
      t.string :contact_name
      t.string :telephone
      t.text :comment
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
