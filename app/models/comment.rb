class Comment < ActiveRecord::Base
  belongs_to   :ticket
  belongs_to   :user
  
  validates :body, allow_blank: true, allow_nil: true, length: {
	maximum: 250,
	message: 'can only have 250 characters, please turn Javascript back on.'
  }
  
end