class Report < ActiveRecord::Base
  
  def self.get_summary(project, section)
    
      member_ids = Member.student_members_user_ids( project, section )
      
      
  end
end