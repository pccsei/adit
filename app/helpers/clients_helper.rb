module ClientsHelper 

  # Checks to see if the current user is permitted to obtain another client
  def more_tickets_allowed
    if Project.is_specific(get_current_project.id)
      Ticket.more_clients_allowed(current_user, get_current_project, current_user.role, 'low')
    else
      Ticket.total_allowed_left(current_user, get_current_project) > 0
    end
  end

  # Takes a user's id and displays first name, last name, and school id
  def get_submitter_info(submitter_id, br_include = true)
    # Check if school id should be on a separate line
    if br_include
      b = "<br />" 
    else 
      b = " "
    end
    
    u = User.find(submitter_id)
    "#{u.first_name} #{u.last_name}#{b}(#{u.school_id})".html_safe
  end 
  
  # Splits up a phone number so that it can be displayed nicely by the 
  #   number_to_phone rails helper
  def render_phone(phone_number)
     if phone_number.present?  
        if phone_number.include? "ext."
           ext = phone_number.partition("ext.")
           number_to_phone(ext[0], extension: ext[2])
        else
           number_to_phone(phone_number)
        end
     else
        nil
     end
  end
  
end
