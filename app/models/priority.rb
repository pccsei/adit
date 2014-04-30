class Priority < ActiveRecord::Base
  has_many :tickets
  
  #Will be used once new seed file has been created
  def self.retrieve(client, project)
     # Set the default priority to low for both fall and spring semesters	 
     value = (Priority.find_by name: "low").id
	 
	   # Set priorities for the Spring semester
       if (project.semester == "Spring")      
	      # IF there exists sales in the last year, give the ticket a high priority
          if (client.receipts.where("made_sale = ? AND ticket_id IN (?)", true,
             (client.tickets.where("project_id IN (?)", Project.where("year = ?", (project.year - 1)).ids)))).present?
            value = (Priority.find_by name: "high").id
          # IF there exists sales 2 or 3 years ago, give the ticket a medium priority			
          elsif (client.receipts.where("made_sale = ? AND ticket_id IN (?)", true, 
		        (client.tickets.where("project_id IN (?)", Project.where("? <= year AND year <= ?", (project.year - 3), (project.year - 2)).ids)))).present?
            value = (Priority.find_by name: "medium").id
          end
	   # Set priorities for the Fall semester
       else
	      # IF there exists a sale in spring of the same year or fall of the last year, 
		  #    the priority will be high
          if (client.receipts.where("made_sale = ? AND ticket_id IN (?)", true, 
		     (client.tickets.where("project_id IN (?)", 
			         Project.where("semester = ? AND year = ? OR semester = ? AND year = ?", 
					               "Spring", (project.year), "Fall", (project.year - 1)).ids)))).present? 
            value = (Priority.find_by name: "high").id
		  # IF there exists a sale in spring of last year, two years ago, or
		  #    fall of three years ago, the priority should be medium
          elsif (client.receipts.where("made_sale = ? AND ticket_id IN (?)", true, 
		        (client.tickets.where("project_id IN (?)", 
				        Project.where("semester = ? AND year = ? OR year = ? OR semester = ? AND year = ?", 
						              "Spring",(project.year - 1), (project.year - 2), "Fall", (project.year - 3)).ids)))).present?
            value = (Priority.find_by name: "medium").id
          end    
       end
	    
    return value
  end
end
