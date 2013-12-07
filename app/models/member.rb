class Member < ActiveRecord::Base
  belongs_to :users
  belongs_to :projects
  
        
def self.project_members(project)
  self.where("project_id = ? AND is_enabled = 1", project.id)
end

end
