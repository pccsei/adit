class User < ActiveRecord::Base
  
  validates :name, :school_id, :email, :extension, presence: true
  validates :school_id, uniqueness: true
  validates :email, format: {
    with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\z/,
    message: 'must be a valid school email address'
  }
  validates :extension, uniqueness: true
  validates :extension, format: {
    with: /\d{4}-\d{1}/,
    message: 'must be a valid phone extension'
  }, length: {
    minimum: 6, maximum: 6,
    message: 'is in the wrong length'
  }
end
