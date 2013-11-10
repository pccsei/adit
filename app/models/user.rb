class User < ActiveRecord::Base
  belongs_to :user
  has_many   :tickets
  has_many   :receipts
  has_many   :bonuses
  
  validates :name, :school_id, :email, :extension, presence: true
  validates :school_id, uniqueness: true
  validates :email, format: {
    with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\z/,
    message: 'must be a valid school email address'
  }

end
