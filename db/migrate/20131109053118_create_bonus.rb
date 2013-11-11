class CreateBonus < ActiveRecord::Migration
  def change
    create_table :bonus do |t|
      t.integer :points
      t.string :comment

      t.timestamps
    end
  end
end
