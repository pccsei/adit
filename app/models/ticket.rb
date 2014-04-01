class Ticket < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :priority
  belongs_to :user
  has_many   :comments
  has_many   :receipts
  has_paper_trail

  def self.current_project(project_id)
    where('project_id = ?', project_id)
  end

  def self.updates(stamp)
    # Grab all updates and append system time to push to the fron end
    tickets = select('id, client_id, user_id').where('updated_at >= ?', stamp).all
    Struct.new('Update', :id, :client_id, :user_id, :first_name, :last_name, :school_id)
    
    updates = []  
    tickets.each_with_index do |t, i|
      updates[i]            = Struct::Update.new
      updates[i].id         = t.id
      updates[i].client_id  = t.client_id
      updates[i].user_id    = t.user_id
      
      if t.user_id == 0 || t.user_id.nil?
        updates[i].first_name = ''
        updates[i].last_name  = ''
        updates[i].school_id  = ''
      else
        user                  = User.find(t.user_id)
        updates[i].first_name = user.first_name
        updates[i].last_name  = user.last_name
        updates[i].school_id  = user.school_id
      end
    end   
    
    updates << Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')
    
  end

  def self.createTickets(project)
    clients = Client.house
    clients.each do |c|
      c.tickets.create(:project_id => project.id, :priority_id => (Priority.retrieve(c,project)))
    end
  end

  def self.createTicketsForStudents(project, clients)
    tickets = []
    clients.each do |c|
      tickets << c.tickets.create(:project_id => project.id, :priority_id => (Priority.retrieve(c,project)))
    end

    return tickets
  end

  # Boolean method that returns whether or not a student may receive more clients
  # The three parameters are student - who is getting the ticket, project - for which project, and
  #   access_role - the role of who is trying to add the student
  def self.more_clients_allowed(student, project, access_role, ticket_priority)
    # The total tickets that the student already holds
    current_tickets = student.tickets.where('(id IN (?) OR id IN (?)) AND project_id = ?',
                                            Receipt.where('user_id = ? AND made_sale = ?',
                                                          student.id, false).pluck(:ticket_id),
                                            Ticket.where('client_id IN (?)', Client.pending.ids),
                                            project.id)

    # Neither student nor teacher can break the max clients setting
    if (current_tickets.size >= project.max_clients) && (project.max_clients != -1)
      result = false
      # If a teacher is trying to add this client, priorities do not matter
    elsif access_role > 2
      result = true

      # If a student is trying to add this client, priorities do matter
    elsif ticket_priority == 'high'
      result = (project.max_high_priority_clients == -1) ||
          (project.max_high_priority_clients > current_tickets.where('priority_id = ?', Priority.where('name = ?', 'high')).size)
    elsif ticket_priority == 'medium'
      result = (project.max_medium_priority_clients == -1) ||
          (project.max_medium_priority_clients > current_tickets.where('priority_id = ?', Priority.where('name = ?', 'medium')).size)
    else
      result = (project.max_low_priority_clients == -1) ||
          (project.max_low_priority_clients > current_tickets.where('priority_id = ?', Priority.where('name = ?', 'low')).size)
    end

    return result
  end

  def self.get_current_tickets(uid, pid)
    where('project_id = ? AND id IN (?) AND user_id = ?', pid, Receipt.where('user_id = ? AND made_sale = ?', uid, false).pluck(:ticket_id) +
        Ticket.where('client_id IN (?)', Client.pending.ids).ids, uid)
  end

  def self.total_allowed_left(uid, project)
    project.max_clients - get_current_tickets(uid, project.id).size
  end

  def self.high_allowed_left(uid, project)

    total_allowed = total_allowed_left(uid, project)
    if project.max_high_priority_clients == -1
      total_allowed
    else
      total_left = project.max_high_priority_clients -
          get_current_tickets(uid, project.id).where('priority_id = ?', Priority.where('name = ?', 'high')).size
      total_allowed < total_left ? total_allowed : total_left
    end
  end

  def self.medium_allowed_left(uid, project)
    total_allowed = total_allowed_left(uid, project)
    if project.max_medium_priority_clients == -1
      total_allowed
    else
      total_left = project.max_medium_priority_clients -
          get_current_tickets(uid, project.id).where('priority_id = ?', Priority.where('name = ?', 'medium')).size
      total_allowed < total_left ? total_allowed : total_left
    end

  end

  def self.low_allowed_left(uid, project)
    total_allowed = total_allowed_left(uid, project)
    if project.max_low_priority_clients == -1
      total_allowed
    else
      total_left = project.max_low_priority_clients -
          get_current_tickets(uid, project.id).where('priority_id = ?', Priority.where('name = ?', 'low')).size
      total_allowed < total_left ? total_allowed : total_left
    end
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
