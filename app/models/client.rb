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
    message: 'must only have letters (no digits).'
  }
 
# Validates the zipcode
  validates :zipcode, allow_blank: true, length:{
    minimum: 4, maximum: 5,
    message: 'is the wrong length.  Needs to be between four to five digits long.'
  }, numericality: { greater_than: 0 }
   
# Validates the email
#  validates :email, allow_blank: true, uniqueness: true, format: {
#    with: /\A([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}\Z/,
#    message: 'must be a valid email address.'
#  }
   
# Validates the contact first and last name
  validates :contact_fname, :contact_lname, allow_blank: true, format: {
    with: /\A[-a-zA-Z ?()'\/&-\.]+\Z/,
    message: 'must only have letters (no digits).'
  }
   
# Validates the telephone - This validation breaks the seed file
  validates :telephone, allow_blank: true, format: {
    with: /\A(((17)\s*[-]\s*(\d{4})\s*[-]\s*([1-4]{1}))*|((((\d{3})?\s*[-]*\s*)*(\d{3})\s*[-]*\s*(\d{4}))*\s*(([eE][xX][tT])\.?\s*(\d{1,4}))*))\z/,
    message: 'must be a valid telephone number.'
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
    for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = Status.where('status_type = ?', 'Approved').first.id
      pending_client.save
      ticket = Ticket.where('client_id = ?', pending_client.id).first
      Receipt.create(:ticket_id => ticket.id, :user_id => ticket.user_id)
    end
  end
  
    def self.unapprove_clients(array_of_pending_clients)
     for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = Status.where('status_type = ?', 'Unapproved').first.id
      pending_client.save


      if Ticket.where('client_id = ?', pending_client.id).first
        Ticket.where('client_id = ?', pending_client.id).first.destroy
      end

     end
    end

  def self.tickets_for_selected_project(pid)
    ticket_info = Ticket.where(project_id: pid)
        
    Struct.new('Client_ticket', :business_name, :contact_fname, :telephone, :student_lname, :zipcode, :city, :id,
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
    for i in 0..array_of_edited_pending_clients.count-1
      pending_edited_client = Client.find(array_of_edited_pending_clients[i].to_i)
      current_client = Client.find(Client.find(array_of_edited_pending_clients[i].to_i).parent_id)
      if status == 2 || status == 3
        # Anything you don't want copied into the orginal list here
        current_client.update(pending_edited_client.attributes.except('id', 'status_id', 'created_at', 'parent_id'))
        current_client.save(:validate => false)
        pending_edited_client.delete
      else
        pending_edited_client.delete
      end
    end
  end

  def full_name
    "#{contact_fname} #{contact_lname}"
  end
end
