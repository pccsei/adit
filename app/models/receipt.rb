class Receipt < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  has_many   :actions
  
  # def self.released_receipts
    # all :conditions => {['']}
  # end
  
  # Returns all the receipts for the selected project
  def self.selected_project_receipts(project)
    
    tickets = Ticket.current_project(project.id)
    receipts = []
    
    tickets.each do |ticket|
      receipts << ticket.receipts unless ticket.receipts == nil
    end
    
    return receipts
  end
 
end

