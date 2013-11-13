class AddColumnsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :max_clients, :char
    add_column :projects, :max_green_clients, :char
    add_column :projects, :max_white_clients, :char
    add_column :projects, :max_yellow_clients, :char
    add_column :projects, :use_max_clients, :boolean
  end
end
