class Priority < ActiveRecord::Base
  has_many :tickets
  
  #Will be used once new seed file has been created
  def self.retrieve(client, project)
   
   #if project.project_type.name == "Spring"      
   #   if (client.tickets.where(:project_id IN (Project.where(:year (Time.now.year - 1)))).receipts.where(:made_sale true))
   #     return (Priority.find_by name: "high").id
   #   elsif (client.tickets.where(:project_id IN (Project.where(:year (Time.now.year - 1))) :).receipts.made_sale == true)
   #     return (Priority.find_by name: "medium").id
   #end    
  end
end
