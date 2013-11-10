class User < ActiveRecord::Base
  
  validates :name, :school_id, :email, :extension, presence: true
  validates :school_id, uniqueness: true
  validates :email, format: {
    with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\z/,
    message: 'must be a valid school email address'
  }

end
