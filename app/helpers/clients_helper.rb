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
    User.find(submitter_id).school_id
  end
end
