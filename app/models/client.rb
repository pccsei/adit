class Client < ActiveRecord::Base
  has_many :tickets
  belongs_to :status

# Add back validation for address and city and telephone
# Validates the business name
  validates :business_name, presence: true
   
# Validates the city, this should allow blanks in the business name
  validates :city, allow_blank: true, format: {
    with: /\A[ a-zA-Z]+\Z/,
    message: 'must only have letters (no digits).'
  }
 
# Validates the zipcode
  validates :zipcode, allow_blank: true, length:{
    minimum: 5, maximum: 5,
    message: 'is the wrong length.  Needs to be only five digits long.'
  }, numericality: { greater_than: 0 }
   
# Validates the email
  validates :email, allow_blank: true, uniqueness: true, format: {
    with: /\A([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}\Z/,
    message: 'must be a valid email address.'
  }
   
# Validates the contact first and last name
  validates :contact_fname, :contact_lname, allow_blank: true, format: {
    with: /\A[A-Za-z ()'\/&-\.]+\Z/,
    message: 'must only have letters (no digits).'
  }
   
# Validates the telephone
  validates :telephone, allow_blank: true, format: {
    with: /\A(17\s*-\s*\d{4}\s*-\s*[1-4]|((\d{3}\s*-\s*){1,2}\d{4})?(\s*[Ee][Xx][Tt]\.?\s*\d{1,7})?)\Z/,
    message: 'must be a valid telephone number.'
  }

   # Returns all pending clients, needs to be refactored to remove magic number
  def self.pending
    where(status_id: 4).all
  end

  def self.edited_pending
    where(status_id: 5).all
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
    
  def Client.make_pending_edited_client(edited_client, client, client_params)
    if edited_client.attributes == Client.find(client).attributes
      redirect_to "/receipts/my_receipts/#{current_user.id}", notice: 'No change has been made to the client.'
    else
      pending_edited_client = Client.new
      # pending_edited_client.save 
      # render text: pending_edited_client.id
      edited_client = Client.find(client).dup
      pending_edited_client.assign_attributes(client_params)
      pending_edited_client.status_id = 5
      pending_edited_client.parent_id = Client.find(client).id
      pending_edited_client.business_name        
      pending_edited_client.telephone
      pending_edited_client.save(:validate => false)  
    end
  end

  def Client.approve_edited_clients(status, array_of_edited_pending_clients)
    for i in 0..array_of_edited_pending_clients.count-1
      pending_edited_client = Client.find(array_of_edited_pending_clients[i].to_i)
      current_client = Client.find(Client.find(array_of_edited_pending_clients[i].to_i).parent_id)
      if status == 2 || status == 3
        # Anything you don't want copied into the orginal list here
        current_client.update(pending_edited_client.attributes.except("id", "status_id", "created_at", "parent_id"))
        current_client.save(:validate => false)
        pending_edited_client.delete
      else
        pending_edited_client.delete
      end
    end
  end

end
