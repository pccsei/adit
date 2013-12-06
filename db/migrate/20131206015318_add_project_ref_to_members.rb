class AddProjectRefToMembers < ActiveRecord::Migration
  def change
    add_reference :members, :project, index: true
  end
end
