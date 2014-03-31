module ClientsHelper
  
  def ticket_taken(cid) 
    ticket = Ticket.where(client_id: cid, project_id: get_selected_project.id).first  
  
    if ticket
      if ticket.user_id != 0 && ticket.user_id != nil
        false
      else
        ticket.user_id
      end
    else 
      true
    end        
  end

  def more_tickets_allowed
    Ticket.more_clients_allowed(current_user, get_current_project, current_user.role, 'low')
  end

  def get_submitter_info(submitter_id)
    u = User.find(submitter_id)
    "#{u.first_name} #{u.last_name} <br /> (#{u.school_id})".html_safe
  end
  
  
  def render_phone(phone_number)
    if !phone_number.blank?  
     if (phone_number.include? "Ext.") 
        ext = phone_number.partition("Ext.")
        number_to_phone(ext[0], extension: ext[2])
     elsif phone_number.include? "ext."
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
