class Client < ActiveRecord::Base
  has_many :tickets
  belongs_to :status
  has_many :receipts, through: :tickets
  
before_validation do
  self.telephone = self.telephone.gsub('-','')
  self.telephone = self.telephone.gsub('(', '')
  self.telephone = self.telephone.gsub(')', '')
  self.telephone = self.telephone.gsub(' ', '')
end

# Add back validation for address and city and telephone
# Validates the business name
  validates :business_name, presence: true
   
# Validates the city, this should allow blanks in the business name
  validates :city, allow_blank: true, format: {
    with: /\A[-a-zA-Z ?()'\/&-\.]+\Z/,
    message: 'will only accept letters and punctuation.'
  }
 
# Validates the zipcode
  validates :zipcode, allow_blank: true, length:{
    minimum: 4, maximum: 5,
    message: 'needs to be in a range of 4-5 digits.'
  }, numericality: { greater_than: 0 }
   
# Validates the email
  validates :email, allow_blank: true, uniqueness: true, format: {
    with: /\A([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}\Z/,
    message: 'must be in a standard email format.'
  }
   
# Validates the contact first and last name
  validates :contact_fname, :contact_lname, allow_blank: true, format: {
    with: /\A[-a-zA-Z ?()'\/\\&-\.]+\Z/,
    message: 'will only accept letters and punctuation.'
  }
   
# Validates the telephone
  validates :telephone, allow_blank: true, format: {
    with: /\A(((([1-9][0-9][0-9])?\s*([-])?\s*)*([1-9][0-9][0-9])\s*([-])?\s*(\d{4})\s*)?(([eE][xX][tT])\.?\s*(\d{1,6}))?)\z/,
    message: 'must be 7 or 10 (if using area code) digits and \"ext.\" followed with range of 1-6 digits (if using extension).'
  }

   # Returns all pending clients, needs to be refactored to remove magic number
  def self.pending
    where(status_id: Status.where(status_type: 'Pending'))
  end

  def self.edited_pending
    where(status_id: 5)
  end
   
  def self.unapproved
    where(status_id: Status.where(status_type: 'Unapproved'))
  end
   
  def self.house
    where(status_id: Status.where(status_type: ['In House', 'Approved']))
  end

  def self.approved
    where(status_id: Status.where(status_type: 'Approved'))
  end
   
  def self.approve_clients(array_of_pending_clients)
    flash_message = ""
    approved_clients = []

    for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = Status.find_by(status_type: 'Approved').id
      if pending_client.save
        approved_clients[i] = pending_client.business_name
      end
      ticket = Ticket.find_by(client_id: pending_client.id)
      if User.find(pending_client.submitter).role < 3 && ticket.user_id
         Receipt.create(ticket_id: ticket.id, user_id: ticket.user_id)
      end
    end


    approved_clients.compact!

    if approved_clients.count > 0
      if approved_clients.count == 1
        flash_message += approved_clients[0] + " has been approved."
      else
        if approved_clients.count == 2
          flash_message += approved_clients.join(' and ')
        else
          flash_message += approved_clients[0..-2].join(', ') + ", and " + approved_clients[-1].to_s
        end

        flash_message += " have been approved."
      end
    end

    return flash_message

  end
  
    def self.unapprove_clients(array_of_pending_clients)
      flash_message = ""
      unapproved_clients = []

     for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = Status.where('status_type = ?', 'Unapproved').first.id
      if pending_client.save
        unapproved_clients[i] = pending_client.business_name
      end

      if Ticket.where('client_id = ?', pending_client.id).first
        Ticket.where('client_id = ?', pending_client.id).first.destroy
      end

     end

    unapproved_clients.compact!
    if unapproved_clients.count > 0
      if unapproved_clients.count == 1
        flash_message += unapproved_clients[0] + " has been disapproved."
      else
        if unapproved_clients.count == 2
          flash_message += unapproved_clients.join(' and ')
        else
          flash_message += unapproved_clients[0..-2].join(', ') + ", and " + unapproved_clients[-1].to_s
        end
        flash_message += " have been disapproved."
      end
    end

    return flash_message

    end

  def self.tickets_for_selected_project(pid)
    ticket_info = Ticket.where(project_id: pid)
        
    Struct.new('Client_ticket', :business_name, :contact_fname, :telephone, :student_lname, :zipcode, :city, :id, :priority,
                                :state, :contact_lname, :contact_title, :client_id, :address, :email, :student_fname, :student_id, :comment)
    client_ticket = []  
    ticket_info.each_with_index do |t, i|
      client_ticket[i]               = Struct::Client_ticket.new
      client_ticket[i].id            = t.id
      client_ticket[i].business_name = t.client.business_name
      client_ticket[i].contact_fname = t.client.contact_fname
      client_ticket[i].telephone     = t.client.telephone
      client_ticket[i].zipcode       = t.client.zipcode
      client_ticket[i].state         = t.client.state
      client_ticket[i].contact_lname = t.client.contact_lname
      client_ticket[i].contact_title = t.client.contact_title
      client_ticket[i].address       = t.client.address
      client_ticket[i].city          = t.client.city
      client_ticket[i].email         = t.client.email
      client_ticket[i].comment       = t.client.comment
      client_ticket[i].client_id     = t.client_id
      client_ticket[i].priority      = t.priority
      
      if t.user_id == nil || t.user_id == 0 # If the ticket does not have a holder
        client_ticket[i].student_fname = nil
        client_ticket[i].student_lname = nil
        client_ticket[i].student_id    = nil 
      else
        client_ticket[i].student_fname = t.user.first_name
        client_ticket[i].student_lname = t.user.last_name
        client_ticket[i].student_id    = t.user.school_id  
      end
    end 
    client_ticket
  end 
    
  def Client.make_pending_edited_client(edited_client, client, client_params, user_id)
    if edited_client.attributes != Client.find(client).attributes
      pending_edited_client = Client.new
      # pending_edited_client.save 
      # render text: pending_edited_client.id
      edited_client = Client.find(client).dup
      pending_edited_client.assign_attributes(client_params)
      pending_edited_client.status_id = 5
      pending_edited_client.parent_id = Client.find(client).id
      pending_edited_client.business_name        
      pending_edited_client.telephone
      pending_edited_client.submitter = user_id
      pending_edited_client.save(:validate => false)  
    end
  end

  def Client.approve_edited_clients(status, array_of_edited_pending_clients)
    flash_message = "The changes for "
    changed_edited_clients = [] 

    for i in 0..array_of_edited_pending_clients.count-1
      pending_edited_client = Client.find(array_of_edited_pending_clients[i].to_i)
      current_client = Client.find(Client.find(array_of_edited_pending_clients[i].to_i).parent_id)
      if status == 2 || status == 3
        # Anything you don't want copied into the orginal list here
        current_client.update(pending_edited_client.attributes.except('id', 'status_id', 'created_at', 'parent_id'))
        if current_client.save
          changed_edited_clients[i] = pending_edited_client.business_name
        end
        pending_edited_client.delete
      else
        changed_edited_clients[i] = pending_edited_client.business_name
        pending_edited_client.delete
      end
    end

    changed_edited_clients.compact!
    if changed_edited_clients.count > 0
      if changed_edited_clients.count == 1
        flash_message += changed_edited_clients[0]
      else
        if changed_edited_clients.count == 2
          flash_message += changed_edited_clients.join(' and ')
        else
          flash_message += changed_edited_clients[0..-2].join(', ') + ", and " + changed_edited_clients[-1].to_s
        end
      end
      flash_message += " have been " + (status == 1 ? "disapproved." : "approved.")
    end
  end

  def full_name
    "#{contact_fname} #{contact_lname}"
  end
end
