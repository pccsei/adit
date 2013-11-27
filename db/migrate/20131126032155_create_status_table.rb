class CreateStatusTable < ActiveRecord::Migration
  def change
    create_table :status_tables do |t|
	  t.string  :status_type
	  t.boolean :status_enabled
    end
  end
end
