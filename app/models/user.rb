class User < ActiveRecord::Base
  has_many   :tickets
  has_many   :receipts
  has_many   :bonuses
  has_many   :members
  has_many   :comments

  before_create :create_remember_token

# Validates the user's name
  validates :first_name, :last_name, presence: true, format: {
      with: /\A[-a-zA-Z ?()'\/&-\.]+\Z/,
      message: 'has an invalid character(s) entered.'
  }, unless: Proc.new { |user| user.school_id.to_i <= -1 }

# Validates the user's school id
  validates :school_id, presence: true, uniqueness: true, unless: Proc.new { |user| user.school_id.to_i <= -1 }

# Validates the email - uniqueness removed for the EXPO
  validates :email, format: {
      with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\Z/,
      message: 'must be a valid PCC email address (jsmith1234@students.pcci.edu).'
  }, unless: Proc.new { |user| user.school_id.to_i <= -1 }

# Validates the phone number
  validates :phone, allow_blank: true, format: {
      with: /\A(([tT][oO][wW][nN])|(((17)\s*[-]\s*)?(\d{4})\s*[-]*\s*([1-4]{1}))*|(((((([(])?\s*\d{3}\s*([)])?)?\s*[-]*\s*)*(\d{3})\s*[-]\s*(\d{4}))*\s*)?(([eE][xX][tT])\.?\s*(\d{1,4}))*))\z/,
      message: 'can either be 17-####-# (with last # of numbers 1-4) or Town.'
  }, unless: Proc.new { |user| user.school_id.to_i <= -1 }

# Validates the box number
  validates :box, allow_blank: true, length: {
      minimum: 3, maximum: 4,
      message: 'needs to be a range of 3-4 digits long.'
  }, numericality: { greater_than: 0 }, unless: Proc.new { |user| user.school_id.to_i <= -1 }

  ### BEGIN CONFIGURATION ###
  SERVER = 'studentnet.int'        # Active Directory server name or IP
  PORT = 636                       # Active Directory server port (default 389)
  BASE = 'DC=studentnet,DC=int'    # Base to search from
  DOMAIN = 'studentnet.int'        # For simplified user@domain format login
  ### END CONFIGURATION ###

  def self.get_student_info(project, section, choice = 1)
    members = Member.student_members(project, section, choice)
    Struct.new('Person', :id, :first_name, :last_name, :school_id, :email, :phone,
               :student_manager_name, :section_number, :major, :minor, :box, :class, :is_enabled, :m_id)

    students = []
    members.each_with_index do |member, i|
      students[i]                      = Struct::Person.new
      students[i].id                   = member.user_id
      students[i].m_id                 = member.id
      students[i].first_name           = member.user.first_name
      students[i].last_name            = member.user.last_name
      students[i].school_id            = member.user.school_id
      students[i].email                = member.user.email
      students[i].phone                = member.user.phone
      students[i].student_manager_name = Member.get_manager_name(member)
      students[i].section_number       = member.section_number
      students[i].major                = member.user.major
      students[i].minor                = member.user.minor
      students[i].box                  = member.user.box
      students[i].class                = member.user.classification
      students[i].is_enabled           = member.is_enabled
    end
    return students
  end


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.get_array_of_manager_ids_from_project_and_section(project, section)
    members = Member.all
    if !members.empty?
      array_of_manager_ids = Array.new(Member.pluck(:parent_id).uniq!)
      array_of_manager_ids.delete(nil)
      array_of_manager_ids.delete_if{|id| Member.find_by(user_id: id).project_id != project.id}
      if section != 'all'
        array_of_manager_ids.delete_if{|id| Member.find_by(user_id: id).section_number != section.to_i}
      end
      array_of_manager_ids
    end
  end

  def User.parse_students(user_params, section_number, project_id, incorrect_counter)
    # Delete the header line if present
    if user_params.include? 'Course'
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
        user = User.new
        user.school_id = single_student_info[1]
        user.first_name = single_student_info[2].split(', ')[1]
        user.last_name = single_student_info[2].split(', ')[0]
        user.classification = single_student_info[3]
        user.box = single_student_info[5]
        user.phone = single_student_info[6]
        user.email = single_student_info[7]
        user.major = single_student_info[8]
        user.minor = single_student_info[9]
        user.role = 1
        user.save
        if(user.save)
          member = Member.new
          member.user_id = user.id
          member.project_id = project_id
          member.section_number = section_number
          member.is_enabled = true
          member.save
        elsif(single_student_info[1].empty?)
          incorrect_counter -= 1
          user.school_id = incorrect_counter.to_s + '(Empty ID)'
          user.save
        else
          incorrect_counter -= 1
          user.school_id = incorrect_counter.to_s + '(Duplicate ID entered)'
          user.save
        end
      else
        incorrect_counter -= 1
        user = User.new
        user.school_id = incorrect_counter.to_s + '(User already exists)'
        user.first_name = single_student_info[2].split(', ')[1]
        user.last_name = single_student_info[2].split(', ')[0]
        user.classification = single_student_info[3]
        user.box = single_student_info[5]
        user.phone = single_student_info[6]
        user.email = single_student_info[7]
        user.major = single_student_info[8]
        user.minor = single_student_info[9]
        user.role = 1
        user.save
        # user = User.find_by! school_id: single_student_info[1]
        # user.school_id = single_student_info[1]
        # user.first_name = single_student_info[2].split(', ')[1]
        # user.last_name = single_student_info[2].split(', ')[0]
        # user.classification = single_student_info[3]
        # user.box = single_student_info[5]
        # user.phone = single_student_info[6]
        # user.email = single_student_info[7]
        # user.major = single_student_info[8]
        # user.minor = single_student_info[9]
        # user.role = 1
        # user.save
        # if (member = Member.find_by(user_id: (User.find_by school_id: single_student_info[1]).id))
          # member.user_id = user.id
          # member.project_id = project_id
          # member.section_number = section_number
          # member.is_enabled = true
          # member.save
        # else
          # member = Member.new
          # member.user_id = user.id
          # member.project_id = project_id
          # member.section_number = section_number
          # member.is_enabled = true
          # member.save
        # end
       end
    end
  end

  def User.do_selected_option(students, choice, student_manager_id, selected_project, bonus_points, bonus_comment)
    if student_manager_id
      student_manager = User.find(student_manager_id)
    end

    # do selected option, as long as some students are selected
    if students != nil
      if choice == 'Promote Student'
        for i in 0..students.count-1
          user = User.find(students[i])
          member = Member.find_by(user_id: students[i])
          user.role = 2
          member.parent_id = user.id
          member.save
          user.save
        end
      end

      if choice == 'Demote Student'
        for i in 0..students.count-1
          team_leader = User.find(students[i])
          Member.destroy_team(team_leader)
        end
      end


      if choice == 'Inactivate Students'
        for i in 0..students.count-1
          # Destroy team if the student is a team leader. The second parameter "true" signifies that the student manage is to be inactivated.
          member = Member.find_by(user_id: students[i])
          member.parent_id = nil
          User.find(students[i]).role == 2 ? Member.destroy_team(User.find(students[i]), true) : nil
          Member.inactivate_student_status(member)
        end
      end

      if choice == 'Activate Students'
        for i in 0..students.count-1
          member = Member.find_by(user_id: students[i])
          Member.activate_student_status(member)
        end
      end

      if choice == 'Assign Team'
        for i in 0..students.count-1
          member = Member.find_by(user_id: students[i])
          if Member.find_by(parent_id: student_manager).section_number == member.section_number
            if User.find(students[i]).role == 2
              Member.destroy_team(User.find(students[i]))
            end
            member.parent_id = student_manager.id
            member.save
          end
        end
      end

      if choice == 'Assign Bonus Points'
        if bonus_points != 0
          for i in 0..students.count-1
            bonus = Bonus.new
            bonus.points = bonus_points
            bonus.comment = bonus_comment
            bonus.user_id = User.find(students[i]).id
            bonus.project_id = selected_project.id
            bonus.save
          end
        end
      end
    end
  end

# Delete the old teacher Member and add a new teacher member
  def self.change_teacher(p_new_teacher_id, p_old_teacher)
    new_teacher = Member.new

    new_teacher.user_id = p_new_teacher_id
    new_teacher.project_id = p_old_teacher.project_id
    new_teacher.section_number = p_old_teacher.section_number
    new_teacher.is_enabled = true

    p_old_teacher.destroy
    new_teacher.save
  end

  def self.get_number_of_teachers_per_section(array_of_all_sections, project)
    array_of_all_sections.delete 'all'

    number_of_teachers_per_section = []
    for i in array_of_all_sections
      number_of_teachers_per_section[i] = Member.where(user_id: User.all_teachers, section_number: i, project_id: project).count
    end

    number_of_teachers_per_section
  end

  def full_name
    "#{first_name} #{last_name} #{school_id}"
  end

  def teacher_full_name
    "#{first_name} #{last_name}"
  end

# Creates a new Teacher member with the section number. This is all that is done to create a new section 
  def User.create_new_section(teacher_id, section_number, project_id)
    # Current teacher id will get the current teacher user id in the test loop below.
    # not_a_section = true
    # current_teacher_id =1

    # Makeshift test to see if this section is already database. Hopefully this code will be rewritten to be effiecent
    # Member.all.each do |t|
    #   if User.find(t.user_id).role == 3
    #     if t.section_number == section_number.to_i && t.project_id == project_id
    #       current_teacher_id = t.user_id
    #       not_a_section = false
    #     end
    #   end
    # end
    # Only create a new member if it is a new section, otherwise override the existing data
    # if not_a_section
    member = Member.new
    member.user_id = teacher_id
    member.project_id = project_id
    member.section_number = section_number
    member.is_enabled = true
    member.save
    # else
    #   member = Member.find_by(user_id: current_teacher_id, section_number: section_number, project_id: project_id)
    #   member.user_id = teacher_id
    #   member.project_id = project_id
    #   member.section_number = section_number
    #   member.is_enabled = true
    #   member.save
    # end
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

# Returns the managers name for the current section to assign a team
  def self.get_managers_from_current_section(project, section)
      # users = User.where(role: 2)
      # members = Member.where(section_number: section)
      # student_manager = Array[]
      # users.each do |user|
      #   members.each do |member|
      #     if user.id == member.user_id
      #       student_manager.push(user)
      #     end
      #   end
      # end
      # return student_manager
      where(role: 2, id: Member.where(project_id: project, section_number: section).pluck(:user_id))
  end

# Returns all the student users for a project and section
  def self.current_student_users(project, section = 'all')
    student_members = Member.student_members_user_ids(project, section)
    where('id in (?)', student_members)
  end

  def self.current_teachers(project)
    Struct.new('Teacher', :id, :first_name, :last_name, :section_number, :email, :phone, :school_id, :is_enabled, :m_id, :full_name)

    teachers = []
    index = 0
    Member.where(project: project, user_id: User.where(role: 3).ids).each do |m|
      t = User.find(m.user_id)
      teachers[index]                = Struct::Teacher.new
      teachers[index].id             = t.id
      teachers[index].m_id           = m.id
      teachers[index].full_name      = t.first_name + ' ' + t.last_name if t.first_name && t.last_name
      teachers[index].first_name     = t.first_name
      teachers[index].last_name      = t.last_name
      teachers[index].email          = t.email
      teachers[index].phone          = t.phone
      teachers[index].school_id      = t.school_id
      teachers[index].section_number = m.section_number
      teachers[index].is_enabled     = m.is_enabled
      index = index + 1
    end
    teachers
  end

# Returns the manager name for a given user and project
  def self.get_manager_name(student_id, project)
    user = User.find(student_id).members.find_by project_id: project.id
    if user && user.parent_id
      manager = User.find(user.parent_id)
      "#{manager.first_name} " + "#{manager.last_name}"
    else
      nil
    end
  end

  def self.all_students
    where('role = ?', 1)
  end

  def self.all_student_managers
    where('role = ?', 1).all + where('role = ?', 2).all
  end

  def self.all_teachers
    where('role = ?', 3)
  end

  def self.all_teacher_ids
    where('role = ?', 3).ids
  end

  def self.incorrect_students
    where('school_id <= ?', -1)
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

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
