class CreateStatusTable < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
	  t.string  :status_type, :limit => 30
	  t.boolean :status_enabled, :default => true
	  t.timestamps
    end
    
    add_reference :clients, :status, index: true
  end
end
