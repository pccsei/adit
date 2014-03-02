module TicketsHelper
  
  def no_more_tickets
    Ticket.cannot_select_clients(current_user, get_current_project)
  end
  
end
