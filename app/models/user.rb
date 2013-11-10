class User < ActiveRecord::Base
  
  validates :name, :school_id, :email, :room_number, presence: true
  validates :school_id, uniqueness: true
  validates :email, format: {
    with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\z/,
    message: 'must be a valid school email address'
  }
  validates :room_number, uniqueness: true
  validates :room_number, format: {
    with: /(\d{4}-\d{1}|TOWN)/,
    message: 'must be a valid phone extension'
  }, length: {
    minimum: 4, maximum: 6,
    message: 'is in the wrong length'
  }
end
