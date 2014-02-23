class Priority < ActiveRecord::Base
  has_many :tickets
  
  #Will be used once new seed file has been created
  def self.retrieve(client, project)
   
     value = (Priority.find_by name: "medium").id
     if (project.semester == "Spring")      
        if (client.receipts.where("made_sale = ? AND ticket_id IN (?)", true, (client.tickets.where("project_id IN (?)", Project.where("year = ?", (project.year - 1)).ids)))).present?          
          value = (Priority.find_by name: "high").id    
        elsif (client.receipts.where("made_sale = ? AND ticket_id NOT IN (?)", true, (client.tickets.where("project_id IN (?)", Project.where("year < ?", (project.year - 3)).ids)))).present?
          value = (Priority.find_by name: "low").id
        end
     else
        if (client.receipts.where("made_sale = ? AND ticket_id IN (?)", true, (client.tickets.where("project_id IN (?)", Project.where("semester = ? AND year = ? OR semester = ? AND year = ?", "Spring", (project.year), "Fall", (project.year - 1)).ids)))).present? 
          value = (Priority.find_by name: "high").id
        elsif (client.receipts.where("made_sale = ? AND ticket_id NOT IN (?)", true, (client.tickets.where("project_id IN (?)", Project.where("semester = ? AND year < ? OR semester = ? AND year < ?", "Spring",(project.year - 2), "Fall", (project.year - 3)).ids)))).present?
          value = (Priority.find_by name: "low").id
        end    
     end
     value
  end
end
