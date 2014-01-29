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

def User.parse_students(user_params, section_number, project_id)
  # Delete the header line if present
  if user_params.include? "Course"
    no_description_bar = user_params.split("\n")[1..-1] 
    all_student_info = no_description_bar
  else
    all_student_info = user_params.split("\n")
  end

  all_student_ids = [] 
  User.all.each do |user|  
    all_student_ids.push(user.school_id)
  end
  
  # Parse the input
  for i in 0..all_student_info.count-1
    single_student_info = all_student_info[i].split("\t")
    if !all_student_ids.include?(single_student_info[1])
      @user = User.new
      @user.school_id = single_student_info[1]
      @user.first_name = single_student_info[2].split(", ")[1]
      @user.last_name = single_student_info[2].split(", ")[0]
      @user.classification = single_student_info[3]
      @user.box = single_student_info[5]
      @user.phone = single_student_info[6]
      @user.email = single_student_info[7]
      @user.major = single_student_info[8]
      @user.minor = single_student_info[9]
      @user.role = 1
      @user.save
      if(@user.save)
        @member = Member.new
        @member.user_id = @user.id
        @member.project_id = project_id
        @member.section_number = section_number
        @member.is_enabled = true
        @member.save
      end
    else
      @user = User.find_by! school_id: single_student_info[1]
      @user.school_id = single_student_info[1]
      @user.first_name = single_student_info[2].split(", ")[1]
      @user.last_name = single_student_info[2].split(", ")[0]
      @user.classification = single_student_info[3]
      @user.box = single_student_info[5]
      @user.phone = single_student_info[6]
      @user.email = single_student_info[7]
      @user.major = single_student_info[8]
      @user.minor = single_student_info[9]
      @user.role = 1
      @user.save
      @member = Member.find_by(user_id: (User.find_by! school_id: single_student_info[1]).id)
      @member.user_id = @user.id
      @member.project_id = project_id
      @member.section_number = section_number
      @member.is_enabled = true
      @member.save
    end
  end
end

def User.do_selected_option(students, choice, student_manager_id, selected_project)
  if student_manager_id
    student_manager = User.find(student_manager_id)
  end
  
  # do selected option, as long as some students are selected
  if students != nil
    if choice == "Promote_Student"
      for i in 0..students.count-1
        user = User.find(students[i])
        member = Member.where("user_id = ?", students[i]).last
        user.role = 2
        member.parent_id = user.id
        member.save       
        user.save
        end
      end

    if choice == "Demote_Student"
      for i in 0..students.count-1
        user = User.find(students[i])
        current_member = Member.where("user_id = ?", students[i]).last
        user.role = 1
        members = Member.where("project_id = ?", selected_project.id)
         members.each do |m|
          if current_member.parent_id == m.parent_id
            m.parent_id = nil
            m.save
          end
        end 
        user.save
      end
    end
  
  
    if choice == "Delete_Student"
      for i in 0..students.count-1
        user = User.find(students[i])
        current_member = Member.where("user_id = ?", students[i]).last
        if user.role == 2
          members = Member.where("project_id = ?", selected_project.id)
          members.each do |m|
            if current_member.parent_id == m.parent_id
              m.parent_id = nil
              m.save
            end
          end 
        end
        current_member.destroy
        current_member.save
      end
    end
  
  
    if choice == "Create_Team"
      for i in 0..students.count-1
        user = User.find(students[i])
        member = Member.where("user_id = ?", students[i]).last
        member.parent_id = student_manager.id
        member.save
      end
    end
  end


  # This is the only function that is not currently working for the drop down box.
  # This will need to reference the section drop-down box
  # obviously no students students need to be selected here 
=begin 
  if choice == "Delete_Everybody"
    User.all.each do |f|
      f.destroy
      f.save
    end
  end
=end
end

def User.encrypt(token)
   Digest::SHA1.hexdigest(token.to_s)
end

def self.all_students
  where("role = ?", 1).all
end

def self.all_student_managers
  where("role = ?", 1).all + where("role = ?", 2).all
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
