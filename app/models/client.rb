class Client < ActiveRecord::Base
  has_many :tickets
  belongs_to :statuses

   #validates :business_name, :address, presence: true
   #validates :telephone, uniqueness: true, allow_blank: true
   #validates :telephone, allow_blank: true, format: {
   #  with: /\A(\d{3}-)?\d{3}-\d{4}\z/,
   #  message: 'is in the wrong format'
   #}
   #validates :email, allow_blank: true, format: {
   #  with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,4})\z/,
   #  message: 'must be a valid email address'
   #}
   
   # Returns all pending clients, needs to be refactored to remove magic number
   def self.pending
     where("status_id = ?", 4).all
   end

  def Client.approve_clients(status, array_of_pending_clients)
    for i in 0..array_of_pending_clients.count-1
      pending_client = Client.find(array_of_pending_clients[i].to_i)
      pending_client.status_id = status
      pending_client.save
    end
  end

end
