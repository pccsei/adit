class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :year
      t.string :semester
      t.string :project_type
      t.datetime :project_start
      t.datetime :project_end
      t.string :comment

      t.timestamps
    end
  end
end
