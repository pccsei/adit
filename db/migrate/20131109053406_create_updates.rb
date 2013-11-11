class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.boolean :is_public
      t.string :comment_text

      t.timestamps
    end
  end
end
