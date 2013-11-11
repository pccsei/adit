class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.float :sale_value
      t.float :page_size

      t.timestamps
    end
  end
end
