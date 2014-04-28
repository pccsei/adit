class AddTableBonus < ActiveRecord::Migration
  def change
    create_table :bonuses do |t|
      t.references :user
      t.references :project
      t.references :bonus_type
      t.string :points_earned, null: false
    end
  end
end
