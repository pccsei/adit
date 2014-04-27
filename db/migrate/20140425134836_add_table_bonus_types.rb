class AddTableBonusTypes < ActiveRecord::Migration
  def change
    create_table :bonus_types do |t|
      t.string :name, null: false
      t.integer :point_value, null: false
      t.boolean :is_active, null: false, default: true       
    end
  end
end
