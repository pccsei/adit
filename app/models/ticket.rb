class Ticket < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :priority
  belongs_to :user
  has_many   :comments
  has_many   :receipts  
  
  def self.current_project(project_id)
    where('project_id = ?', project_id)
  end
  
  def self.updates(stamp)
    # Grab all updates and append system time to push to the fron end
    select('client_id, user_id').where('updated_at >= ?', stamp).all << Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def self.createTickets(project)
    clients = Client.house
    clients.each do |c|
       c.tickets.create(:project_id => project.id, :priority_id => (Priority.retrieve(c,project)))
    end
  end

  # Returns true or false depending on whether a student is able to add another client
  def self.more_clients_allowed(user, project)
    current_tickets = user.tickets.where('project_id = ? AND id IN (?)',
                                          project.id, Receipt.where('user_id = ? AND made_sale = ?',
                                                                    user.id, false).pluck(:ticket_id))
    current_pending = Client.where(status_id: Status.where(status_type: 'Pending'), submitter: (user.first_name + ' ' + user.last_name))
    current_low_tickets = current_tickets.where('priority_id = ?', Priority.where('name = ?', 'low')).size
    result = true
    if project.use_max_clients
      result = false if (project.max_clients <= current_tickets.size || project.max_clients <= (current_pending.size + current_tickets.size))
    else
      result = false if (project.max_low_priority_clients <= current_low_tickets || project.max_low_priority_clients <= (current_pending.size + current_low_tickets))
    end
    return result
  end
  
  def self.get_current_tickets(uid, pid)
    Ticket.where('project_id = ? AND id IN (?) AND user_id = ?', pid, Receipt.where('user_id = ? AND made_sale = ?', uid, false).pluck(:ticket_id), uid)
  end
  
  def self.total_allowed_left(uid, pid)
    project.max_clients - get_current_tickets(uid, pid)
  end
    
  def self.high_allowed_left(uid, project)
    project.max_high_priority_clients - get_current_tickets(uid, project.id).where('priority_id = ?', Priority.where('name = ?', 'high')).size
  end
  
  def self.medium_allowed_left(uid, project)
    project.max_medium_priority_clients - get_current_tickets(uid, project.id).where('priority_id = ?', Priority.where('name = ?', 'medium')).size
  end

  def self.cannot_select_clients(user, project)
    current_tickets  = user.tickets.where('project_id = ? AND id IN (?)',
                                          project.id, Receipt.where('user_id = ? AND made_sale = ?',
                                                                    user.id, false).pluck(:ticket_id))
    result = false
    if project.use_max_clients
      result = true if project.max_clients > current_tickets.size
    else
      result = true if (project.max_low_priority_clients > current_tickets.where('priority_id = ?', Priority.where('name = ?', 'low')).size &&
                        project.max_medium_priority_clients > current_tickets.where('priority_id = ?', Priority.where('name = ?', 'medium')).size &&
                        project.max_high_priority_clients > current_tickets.where('priority_id = ?', Priority.where('name = ?', 'high')).size)
    end
    return result
  end

  def self.low_allowed_left(uid, project)
    project.max_low_priority_clients - get_current_tickets(uid, project.id).where('priority_id = ?', Priority.where('name = ?', 'low')).size
  end
  
  def self.more_allowed(uid, project)
    total_allowed_left(uid, project) > 0
  end
  
  def self.more_high_allowed(uid, project)
    high_allowed_left(uid, project) > 0
  end
  
  def self.more_medium_allowed(uid, project)
    medium_allowed_left(uid, project) > 0
  end  

  def self.more_low_allowed(uid, project)
    low_allowed_left(uid, project) > 0
  end

end
