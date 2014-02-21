class Client < ActiveRecord::Base
  has_many :tickets
  belongs_to :statuses

# Validates the business name
  validates :business_name, presence: true, uniqueness: true
   
# Validates the address
  validates :address, presence: true
   
# Validates the city
  validates :city, presence: true, format: {
    with: /\A[-a-zA-Z]+\z/,
    message: 'must only have letters (no digits).'
  }
 
# Validates the zipcode
  validates :zipcode, presence: true, length:{
    minimum: 5, maximum: 5,
    message: 'is the wrong length.  Needs to be only five digits long.'
  }, numericality: { greater_than: 0 }
   
# Validaates the email
  validates :email, allow_blank: true, uniqueness: true, format: {
    with: /\A([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}\z/,
    message: 'must be a valid email address.'
  }
   
# Validates the contact first and last name
  validates :contact_fname, :contact_lname, presence: true, format: {
    with: /\A[-a-zA-Z]+\z/,
    message: 'must only have letters (no digits).'
  }
   
# Validates the telephone
  validates :telephone, presence: true, uniqueness: true, format: {
    with: /\A(\((\d{3})\)|(\d{3}))?\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*\z/,
    message: 'must be a valid telephone number.'
  }

   # Returns all pending clients, needs to be refactored to remove magic number
  def self.pending
    where(status_id: 4).all
  end
   
  def self.unapprove
    where(status_id: 1).all
  end
   
  def self.house
    where(status_id: [3,2]).all
  end
   
  def Client.approve_clients(status, array_of_pending_clients)
    for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = status
      pending_client.save
    end
  end

  def self.for_selected_project(pid)
    basic_client_info = Client.house
    
    Struct.new("Client_detail", :id,    :business_name, :contact_fname, :telephone, :website, :student_lname, :zipcode, :email, :city, 
                                :state, :contact_lname, :contact_title, :ticket_id, :address, :student_fname, :student_id, :comment)
    client_info = []  
    basic_client_info.each_with_index do |c, i|
      client_info[i] = Struct::Client_detail.new
      client_info[i].id = c.id
      client_info[i].business_name = c.business_name
      client_info[i].contact_fname = c.contact_fname
      client_info[i].email = c.email
      client_info[i].telephone = c.telephone
      client_info[i].website = c.website
      client_info[i].zipcode = c.zipcode
      client_info[i].state = c.state
      client_info[i].contact_lname = c.contact_lname
      client_info[i].contact_title = c.contact_title
      client_info[i].city = c.city
      client_info[i].comment = c.comment
      
      client_ticket = Ticket.where(client_id: c.id, project_id: pid).first
      
      if client_ticket && client_ticket.user_id != 0
        user = User.find(client_ticket.user_id)
        
        client_info[i].ticket_id     = client_ticket.id
        client_info[i].student_fname = user.first_name
        client_info[i].student_lname = user.last_name
        client_info[i].student_id    = user.school_id
      else 
        client_info[i].ticket_id     = nil
        client_info[i].student_fname = nil
        client_info[i].student_lname = nil
        client_info[i].student_id    = nil        
      end
      
    end
    client_info
  end

end
