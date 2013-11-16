class FixProjects < ActiveRecord::Migration
    def up
      change_table :projects do |t|
        t.change :max_clients, :integer, :limit => 2
        t.change :max_green_clients, :integer, :limit => 2
        t.change :max_white_clients, :integer, :limit => 2
        t.change :max_yellow_clients, :integer, :limit => 2
      end
    end
    
    def down
      change_table :projects do |t|
        t.change :max_clients, :string, :limit => 1
        t.change :max_green_clients, :string, :limit => 1
        t.change :max_white_clients, :string, :limit => 1
        t.change :max_yellow_clients, :string, :limit => 1
      end
    end
end

