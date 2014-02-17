class Priority < ActiveRecord::Base
  has_many :tickets
  
  #Will be used once new seed file has been created
  #def self.retrieve(client)
  #  if (client.tickets.receipts.made_sale == true)    
  #end
end
