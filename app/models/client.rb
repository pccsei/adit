class Client < ActiveRecord::Base
<<<<<<< HEAD
  validates :business_name, :address, presence: true
  validates :telephone, uniqueness: true, allow_blank: true
  validates_format_of :telephone, allow_blank: true,
    with: /\d{3}-\d{3}-\d{4}/,
    message: 'is in the wrong XXX-XXX-XXXX format'
  validates_format_of :email, allow_blank: true,
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,4})\z/,
    message: 'must be a valid email address'
  validates_format_of :website, allow_blank: true,
    with: /\A([^@\s]+)((?:[-a-z0-9]+\.)+[a-z]{2,})\z/,
    message: 'must be a valid website address'
=======
>>>>>>> origin/master
end
