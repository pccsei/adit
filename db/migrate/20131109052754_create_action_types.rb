class CreateActionTypes < ActiveRecord::Migration
  def change
    create_table :action_types do |t|
      t.string :name
      t.integer :role
      t.integer :point_value

      t.timestamps
    end
  end
end
