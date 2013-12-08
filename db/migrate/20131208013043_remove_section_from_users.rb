class RemoveSectionFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :section, :integer
  end
end
