class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.integer :level
      t.string :name

      t.timestamps
    end
  end
end
