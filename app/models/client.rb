class Client < ActiveRecord::Base
  has_many :tickets
  belongs_to :statuses

   validates :business_name, :address, presence: true
   #validates :telephone, uniqueness: true, allow_blank: true
   #validates :telephone, allow_blank: true, format: {
   #  with: /\A(\d{3}-)?\d{3}-\d{4}\z/,
   #  message: 'is in the wrong format'
   #}
   validates :email, allow_blank: true, format: {
     with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,4})\z/,
     message: 'must be a valid email address'
   }

end
