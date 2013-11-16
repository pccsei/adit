class User < ActiveRecord::Base
  belongs_to :user
  has_many   :tickets
  has_many   :receipts
  has_many   :bonuses
  
  validates :school_id, :email, :phone, presence: true
  validates :school_id, uniqueness: true
  validates :email, format: {
    with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\z/,
    message: 'must be a valid school email address'
  }
  validates :phone, uniqueness: true, format: {
    with: /(17-)\d{4}-\d{1}/,
    message: 'is in the wrong 17-XXXX-X format'
  }, length: {
    minimum: 9, maximum: 9,
    message: 'is the wrong length'
  }
end
