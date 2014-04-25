class User < ActiveRecord::Base
  has_many   :tickets
  has_many   :receipts
  has_many   :bonuses
  has_many   :members
  has_many   :comments
  has_paper_trail

  before_create :create_remember_token

# Validates the user's name
  validates :first_name, :last_name, presence: true, format: {
      with: /\A[-a-zA-Z ?()'\/&-\.]+\Z/,
      message: 'has an invalid character(s) entered.'
  }, unless: Proc.new { |user| user.school_id.to_i <= -1 },
     length: {
        maximum: 30,
		message: 'has a maximum length of 30 characters.'
  }

# Validates the user's school id
  validates :school_id, presence: true, uniqueness: true, unless: Proc.new { |user| user.school_id.to_i <= -1 }

# Validates the email
  validates :email, uniqueness: true, format: {
      with: /\A([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)\Z/,
      message: 'must be a valid PCC email address (jsmith1234@students.pcci.edu).'
  }, unless: Proc.new { |user| user.school_id.to_i <= -1 },
     length: {
        maximum: 35,
		message: 'has a maximum length of 35 characters.'
  }


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
  
# Validates the major and minor
  validates :major, :minor,
     length: {
        maximum: 75,
		message: 'has a maximum length of 75 characters.'
  }


  ### BEGIN CONFIGURATION ###
  SERVER = 'studentnet.int'        # Active Directory server name or IP
  PORT = 636                       # Active Directory server port (default 389)
  BASE = 'DC=studentnet,DC=int'    # Base to search from
  DOMAIN = 'studentnet.int'        # For simplified user@domain format login
  ### END CONFIGURATION ###

  def self.get_student_info(project, section, choice = 1)
    members = Member.student_members(project, section, choice)
    Struct.new('Person', :id, :first_name, :last_name, :school_id, :email, :phone, :role,
               :student_manager_name, :section_number, :major, :minor, :box, :class, :is_enabled, :m_id)

    students = []
    members.each_with_index do |member, i|
      students[i]                      = Struct::Person.new
      students[i].id                   = member.user_id
      students[i].m_id                 = member.id
      students[i].role                 = member.user.role
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

  def User.parse_students(user_params, section_number, project_id)
    message = "" #Message containing names of people already in the project
    invalid_count = 0 #Number of students that already were members of the project
    illegal_count = 0 #Number of illegally entered students
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
      # Check to see if the current student being processed already exists as a user
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
        user.role = STUDENT
        user.save
        if(user.save)
          member = Member.new
          member.user_id = user.id
          member.project_id = project_id
          member.section_number = section_number
          member.is_enabled = true
          member.save
        else
          illegal_count += 1
        end
      # The student user already exists in the database
      else
        user = User.find_by! school_id: single_student_info[1]
        user.school_id = single_student_info[1]
        user.first_name = single_student_info[2].split(', ')[1]
        user.last_name = single_student_info[2].split(', ')[0]
        user.classification = single_student_info[3]
        user.box = single_student_info[5]
        user.phone = single_student_info[6]
        user.email = single_student_info[7]
        user.major = single_student_info[8]
        user.minor = single_student_info[9]
        user.role = STUDENT
        user.save
        # Check to see if they are already a member of the project
        if (Member.where(user_id: user.id, project_id: project_id).empty?)
          member = Member.new
          member.user_id = user.id
          member.project_id = project_id
          member.section_number = section_number
          member.is_enabled = true
          member.save
        else
          message += user.first_name + " " + user.last_name + ", "
          invalid_count += 1
        end
       end
    end
    
    if message.present?
      message = message[0..-3]
      if invalid_count > 1      
         message += " were already members of this project." 
      else
        message += " was already a member of this project."
      end
    end
    
    if illegal_count > 0
      message += " At least one student record contained input errors."
    end
    
    if message.present?
      message
    else
      "Your student list was successfully imported."
    end
  end

  # Good luck...
  # Do whatever the teacher specified on the manage students page.
  def User.do_selected_option(students, choice, student_manager_id, selected_project, bonus_points, bonus_comment)
    if student_manager_id
      student_manager = User.find(student_manager_id)
    end

    flash_positive_names=[]
    flash_team_leaders_names=[]
    flash_other_team_leaders_names=[]
    flash_already_teammate_names=[]
    flash_other_team_names=[]
    flash_already_team_leaders=[]
    flash_already_not_team_leaders=[]
    flash_not_on_a_team=[]
    flash_message = ""

    # 1 will represent success, 2 failure, 3 mixed
    reponse_int = 0
    is_added_positive = false
    is_added_negative = false

    # do selected option, as long as some students are selected
    if students != nil
      if choice == 'Promote Student'
        for i in 0..students.count-1
          user = User.find(students[i])
          member = Member.find_by(user_id: students[i], project_id: selected_project.id)
          if !Member.is_team_leader(member)
            member.parent_id = user.id
            if member.save && user.save
              if !is_added_positive
                reponse_int += 1
                is_added_positive = true
              end
              flash_positive_names[i] = "#{user.first_name} #{user.last_name}"
            end
          else
            if !is_added_negative
              reponse_int += 2
              is_added_negative = true
            end
            flash_already_team_leaders[i] = "#{user.first_name} #{user.last_name}"
          end
        end

        if reponse_int == 1
        reponse = 'success'
        elsif reponse_int == 2
          reponse = 'error'
        else
          response = 'neutral'
        end

        # Most of the following code is for verb tense
        flash_positive_names.compact!
        if flash_positive_names.count > 0
          if flash_positive_names.count == 1
            flash_message += flash_positive_names[0] + " is now a team leader. "
          else
            if flash_positive_names.count == 2
              flash_message += flash_positive_names.join(' and ')
            else
              flash_message += flash_positive_names[0..-2].join(', ') + ", and " + flash_positive_names[-1].to_s
            end
            flash_message += " are now team leaders. "
          end
        end

        if flash_positive_names.count > 0 && flash_already_team_leaders.count > 0
          flash_message += "However, "
        end

        flash_already_team_leaders.compact!
        if flash_already_team_leaders.count > 0
          if flash_already_team_leaders.count == 1
            flash_message += flash_already_team_leaders[0] + " is already a team leader."
          else
            if flash_already_team_leaders.count == 2
              flash_message += flash_already_team_leaders.join(' and ')
            else
              flash_message += flash_already_team_leaders[0..-2].join(', ') + ", and " + flash_already_team_leaders[-1].to_s
            end
            flash_message += " are already team leaders."
          end
        end

        return reponse, flash_message
      end

      if choice == 'Demote Student'
        for i in 0..students.count-1
          user = User.find(students[i])
          if Member.is_team_leader(Member.find_by(user_id: user, project_id: selected_project.id, parent_id: user.id))
            Member.destroy_team(user)
            if !is_added_positive
              reponse_int += 1
              is_added_positive = true
            end
            flash_positive_names[i] = "#{user.first_name} #{user.last_name}"
          else
            if !is_added_negative
              reponse_int += 2
              is_added_negative = true
            end
            flash_already_not_team_leaders[i] = "#{user.first_name} #{user.last_name}"
          end
        end

        if reponse_int == 1
        reponse = 'success'
        elsif reponse_int == 2
          reponse = 'error'
        else
          response = 'neutral'
        end

        # Most of the following code is for verb tense
        flash_positive_names.compact!
        if flash_positive_names.count > 0
          if flash_positive_names.count == 1
            flash_message += flash_positive_names[0] + " is now just a student. The team has been removed. "
          else
            if flash_positive_names.count == 2
              flash_message += flash_positive_names.join(' and ')
            else
              flash_message += flash_positive_names[0..-2].join(', ') + ", and " + flash_positive_names[-1].to_s
            end
            flash_message += " are now just students. Their teams have been removed. "
          end
        end

        if flash_positive_names.count > 0 && flash_already_not_team_leaders.count > 0
          flash_message += "However, "
        end

        flash_already_not_team_leaders.compact!
        if flash_already_not_team_leaders.count > 0
          if flash_already_not_team_leaders.count == 1
            flash_message += flash_already_not_team_leaders[0] + " was not a student manager to begin with."
          else
            if flash_already_not_team_leaders.count == 2
              flash_message += flash_already_not_team_leaders.join(' and ')
            else
              flash_message += flash_already_not_team_leaders[0..-2].join(', ') + ", and " + flash_already_not_team_leaders[-1].to_s
            end
            flash_message += " were not student managers to begin with."
          end
        end

        return reponse, flash_message
      end

      # Inactivate students
      if choice == 'Deactivate'
        for i in 0..students.count-1
          member = Member.find_by(user_id: students[i])
          member.parent_id = nil
          # Destroy team if the student is a team leader. The second parameter "true" signifies that the student manage is to be inactivated.
          if User.find(students[i]).role == Member.is_team_leader(Member.find_by(project_id: selected_project.id, parent_id: member.user_id))
            Member.destroy_team(User.find(students[i]), true)
          end
          Member.inactivate_student_status(member)
        end
      end

      # Activate students
      if choice == 'Activate'
        for i in 0..students.count-1
          member = Member.find_by(user_id: students[i])
          Member.activate_student_status(member)
        end
      end

      if choice == 'Add to Team'
        if student_manager
          for i in 0..students.count-1
            member = Member.find_by(user_id: students[i])
            user = User.find(students[i])
            if user.role == STUDENT
              if !member.parent_id
                  member.parent_id = student_manager.id
                  if !is_added_positive
                    reponse_int += 1
                    is_added_positive = true
                  end
                  if member.save
                    flash_positive_names[i] = "#{user.first_name} #{user.last_name}"
                  end
              else
                if member.parent_id != student_manager.id
                  flash_other_team_names[i] = "#{user.first_name} #{user.last_name}"
                  if !is_added_negative
                    reponse_int += 2
                    is_added_negative = true
                  end
                else
                  flash_already_teammate_names[i] = "#{user.first_name} #{user.last_name}"
                  if !is_added_negative
                    reponse_int += 2
                    is_added_negative = true
                  end
                end
              end
            else
              if member.parent_id == student_manager.id
                flash_team_leader_name = "#{user.first_name} #{user.last_name}"
                if !is_added_negative
                  reponse_int += 2
                  is_added_negative = true
                end               
              else
                flash_other_team_leaders_names[i] = "#{user.first_name} #{user.last_name}"
                if !is_added_negative
                  reponse_int += 2
                  is_added_negative = true
                end
              end
            end
          end
        end

        if reponse_int == 1
          reponse = 'success'
        elsif reponse_int == 2
          reponse = 'error'
        else
          response = 'neutral'
        end

        # Most of the following code is for verb tense
        flash_positive_names.compact!
        if flash_positive_names.count > 0
          if flash_positive_names.count == 1
            flash_message += flash_positive_names[0] + " was "
          else
            if flash_positive_names.count == 2
              flash_message += flash_positive_names.join(' and ')
            else
              flash_message += flash_positive_names[0..-2].join(', ') + ", and " + flash_positive_names[-1].to_s
            end
            flash_message += " were "
          end
          flash_message += "added to #{student_manager.first_name} #{student_manager.last_name}'s team. "
        end

        if flash_positive_names.count > 0 && (flash_other_team_leaders_names.count > 0  || flash_already_teammate_names.count > 0 || flash_other_team_names.count > 0 || flash_team_leader_name )
          flash_message += "However, "
        end

        if flash_team_leader_name
          flash_message += "#{student_manager.first_name} #{student_manager.last_name}'s is already the team leader of this team. "
        end

        flash_other_team_leaders_names.compact!
        if flash_other_team_leaders_names.count > 0
          if flash_other_team_leaders_names.count == 1
            flash_message += flash_other_team_leaders_names[0] + " is a team leader, and so was"
          else
            if flash_other_team_leaders_names.count == 2
              flash_message += flash_other_team_leaders_names.join(' and ')
            else
              flash_message += flash_other_team_leaders_names[0..-2].join(', ') + ", and " + flash_other_team_leaders_names[-1].to_s
            end
            flash_message += " are team leaders, and so were"
          end
          flash_message += " not assigned to #{student_manager.first_name} #{student_manager.last_name}'s team. "
        end

        flash_already_teammate_names.compact!
        if flash_already_teammate_names.count > 0
          if flash_already_teammate_names.count == 1
            flash_message += flash_already_teammate_names[0] + " is already a teammate"
          else
            if flash_already_teammate_names.count == 2
              flash_message += flash_already_teammate_names.join(' and ')
            else
              flash_message += flash_already_teammate_names[0..-2].join(', ') + ", and " + flash_already_teammate_names[-1].to_s
            end
            flash_message += " are already teammates of"
          end
          flash_message += " of #{student_manager.first_name} #{student_manager.last_name}'s team. "
        end

        flash_other_team_names.compact!
        if flash_other_team_names.count > 0
          if flash_other_team_names.count == 1
            flash_message += flash_other_team_names[0] + " is already a teammate"
          else
            if flash_other_team_names.count == 2
              flash_message += flash_other_team_names.join(' and ')
            else
              flash_message += flash_other_team_names[0..-2].join(', ') + ", and " + flash_other_team_names[-1].to_s
            end
            flash_message += " are already teammates"
          end
          flash_message += " of a different team. "
        end

        return reponse, flash_message
      end

      if choice == 'Remove from Team'
        for i in 0..students.count-1
          user = User.find(students[i])
          member = Member.find_by(user_id: students[i])
          if user.role == STUDENT
            if member.parent_id
              member.parent_id = nil
              if member.save
                if !is_added_positive
                  reponse_int += 1
                  is_added_positive = true
                end
                flash_positive_names[i] = "#{user.first_name} #{user.last_name}"
              end
            else
              if !is_added_negative
                reponse_int += 2
                is_added_negative = true
              end
              flash_not_on_a_team[i] = "#{user.first_name} #{user.last_name}"
            end
          else
            if !is_added_negative
              reponse_int += 2
              is_added_negative = true
            end
            flash_team_leaders_names[i] = "#{user.first_name} #{user.last_name}"
          end
        end

        if reponse_int == 1
          reponse = 'success'
        elsif reponse_int == 2
          reponse = 'error'
        else
          response = 'neutral'
        end

        # Most of the following code is for verb tense
        flash_positive_names.compact!
        if flash_positive_names.count > 0
          if flash_positive_names.count == 1
            flash_message += flash_positive_names[0] + " is now not part of a team. "
          else
            if flash_positive_names.count == 2
              flash_message += flash_positive_names.join(' and ')
            else
              flash_message += flash_positive_names[0..-2].join(', ') + ", and " + flash_positive_names[-1].to_s
            end
            flash_message += " are now not part of a team. "
          end
        end

        if flash_positive_names.count > 0 && (flash_not_on_a_team.count > 0 || flash_team_leaders_names.count > 0)
          flash_message += "However, "
        end

        flash_not_on_a_team.compact!
        if flash_not_on_a_team.count > 0
          if flash_not_on_a_team.count == 1
            flash_message += flash_not_on_a_team[0] + " is already not a part of any team. "
          else
            if flash_not_on_a_team.count == 2
              flash_message += flash_not_on_a_team.join(' and ')
            else
              flash_message += flash_not_on_a_team[0..-2].join(', ') + ", and " + flash_not_on_a_team[-1].to_s
            end
            flash_message += " are already not a part of any team. "
          end
        end

        flash_team_leaders_names.compact!
        if flash_team_leaders_names.count > 0
          if flash_team_leaders_names.count == 1
            flash_message += flash_team_leaders_names[0] + " is a team leader of another team. Demote this student to remove the team. "
          else
            if flash_team_leaders_names.count == 2
              flash_message += flash_team_leaders_names.join(' and ')
            else
              flash_message += flash_team_leaders_names[0..-2].join(', ') + ", and " + flash_team_leaders_names[-1].to_s
            end
            flash_message += " are team leaders. Demote them to remove their teams. "
          end
        end

        return reponse, flash_message
      end

      # Change this function after the EXPO, so that it validates user input as well.
      if choice == 'Assign Bonus Points'
        if bonus_points != 0 && bonus_points != nil
          flash_positive_message = " "
          response = "success"
          for i in 0..students.count-1
            bonus = Bonus.new
            bonus.points = bonus_points
            bonus.comment = bonus_comment
            user = User.find(students[i])
            bonus.user_id = user.id
            bonus.project_id = selected_project.id
            if bonus.save
              if students.count == 1
                return response, flash_positive_message += "#{user.first_name} #{user.last_name} was given #{bonus_points} bonus points."
              elsif i < students.count-1
                # If only two names do not add a comma
                flash_positive_message += "#{user.first_name} #{user.last_name}"
                (students.count == 2) ? flash_positive_message += ' ' : flash_positive_message +=', '
              else
                return response, flash_positive_message += "and #{user.first_name} #{user.last_name} were given #{bonus_points} bonus points."
              end
            end
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

  # Returns an array of the number of teachers in each section
  def self.get_number_of_teachers_per_section(array_of_all_sections, project)
    array_of_all_sections.delete 'all'

    number_of_teachers_per_section = []
    for i in array_of_all_sections
      number_of_teachers_per_section[i] = Member.where(user_id: User.all_teachers, section_number: i, project_id: project).count
    end

    number_of_teachers_per_section
  end

  def full_name
    "#{first_name} #{last_name} (#{school_id})"
  end

  def teacher_full_name
    "#{first_name} #{last_name}"
  end

  def full_name_only
    "#{first_name} #{last_name}"
  end

  # Creates a new Teacher member with the section number. This is all that is done to create a new section 
  def User.create_new_section(teacher_id, section_number, project_id)
    member = Member.new
    member.user_id = teacher_id
    member.project_id = project_id
    member.section_number = section_number
    member.is_enabled = true
    member.save
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Returns the managers name for the current section to assign a team
  def self.get_managers_from_current_section(project, section)
      users = User.where(role: STUDENT)
      members = Member.where(section_number: section, project_id: project)
      student_manager = Array[]
      users.each do |user|
        members.each do |member|
          if user.id == member.user_id && user.id == member.parent_id
            student_manager.push(user)
          end
        end
      end
      return student_manager
      # where(id: Member.where(project_id: project, section_number: section, parent_id: user_id).pluck(:user_id))
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
    Member.where(project: project, user_id: User.where(role: TEACHER).ids).each do |m|
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
    where('role = ?', STUDENT)
  end

  def self.all_student_managers
    where(parent_id: user_id)
  end

  def self.all_teachers
    where('role = ?', TEACHER)
  end

  def self.all_teacher_ids
    where('role = ?', TEACHER).ids
  end

  def self.team_members(project, team_leader_id)
    where(id: Member.where(parent_id: team_leader_id, project_id: project).pluck(:user_id))
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
