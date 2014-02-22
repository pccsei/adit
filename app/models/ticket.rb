class Ticket < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :priority
  belongs_to :user
  has_many   :comments
  has_many   :receipts  
  
  
  
  def self.current_project(project_id)
    where("project_id = ?", project_id)
  end
  
  def self.updates(stamp)
    # Grab all updates and append system time to push to the fron end
    select("client_id, user_id").where("updated_at >= ?", stamp).all << Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
  end
  


  def self.createTickets(project)
    clients = Client.house
    clients.each do |c|
        # Will be used once we have priorities to work from
          #c.ticket.create(:project_id => project.id, :priority_id => Priority.retrieve(c))
          #c.tickets.create(:project_id => project.id, :priority_id => Priority.retrieve(c,project))
      end
  end

end
