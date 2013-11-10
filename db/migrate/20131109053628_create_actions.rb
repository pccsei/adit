class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :points_earned
      t.datetime :user_action_time

      t.timestamps
    end
  end
end
