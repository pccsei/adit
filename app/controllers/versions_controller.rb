class VersionsController < ApplicationController
  def revert_action
    @version = PaperTrail::Version.find(params[:id])
    @version.reify.save!
    
    a = Action.find(@version.item_id)
    r = Receipt.find(a.receipt_id)
    case a.action_type.name 
    when "First Contact"
      r.made_contact = true
    when "Presentation"
      r.made_presentation = true
    when "New Sale", "Old Sale"
      r.made_sale = true
    end    
      r.save!
    
    version_cleanup(r.user_id, "Action")
    
    # Find action by id and retrieve action_type.name
    # Find Receipt id from action.receipt id and set contact, presentation, or sale based on action_type.name
    redirect_to :back, :notice => "Undo Successful"
  end
  
  
  
  def revert_assign
    @version = PaperTrail::Version.find(params[:id])
    @version.reify.save!
    redirect_to :back, :notice => "Undo Successful"
  end
  
  
  
end
