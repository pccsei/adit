wclass Ticket < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :priority
  belongs_to :user
  has_many   :receipts  
  
  
  def self.current_project(project_id)
    where("project_id = ?", project_id)
  end
  
  def self.updates(stamp)
    # Grab all updates and append system time to push to the fron end
    select("client_id, user_id").where("updated_at >= ?", stamp).all << Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
  end
  
end

def createTickets
  clients.each do |c|
      c.ticket.create
    end
  end

