class User < ActiveRecord::Base
  belongs_to :user
  has_many   :tickets
  has_many   :receipts
  has_many   :bonuses
  has_many   :members
  
  before_create :create_remember_token
=begin
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
=end

      ### BEGIN CONFIGURATION ###
      SERVER = 'studentnet.int'        # Active Directory server name or IP
      PORT = 636                       # Active Directory server port (default 389)
      BASE = 'DC=studentnet,DC=int'    # Base to search from
      DOMAIN = 'studentnet.int'        # For simplified user@domain format login
      ### END CONFIGURATION ###

def User.new_remember_token
  SecureRandom.urlsafe_base64
end


def User.encrypt(token)
   Digest::SHA1.hexdigest(token.to_s)
end

def self.all_students
  where("role = ?", 1).all
end

def self.all_teachers
  where("role = ?", 3).all
end

def self.authenticate(login, pass)
        return false if login.empty? or pass.empty?

        conn = Net::LDAP.new :host => SERVER,
                             :port => PORT,
                             :base => BASE,
                             :encryption => :simple_tls,
                             :auth => { :username => "#{login}@#{DOMAIN}",
                                        :password => pass,
                                        :method => :simple }
        if conn.bind
          return true
        else
          return false
        end
      # If we don't rescue this, Net::LDAP is decidedly ungraceful about failing
      # to connect to the server. We'd prefer to say authentication failed.
      rescue Net::LDAP::LdapError => e
        return false
      end
    end

private

   def create_remember_token
     self.remember_token = User.encrypt(User.new_remember_token)
   end
