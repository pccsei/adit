class ReportsController < ApplicationController
  
  def sales
    render text: session[:selected_section_id]
  end
  
  def student_summary
    
  end
  
  def team_summary
    
  end
  
  def activity
    
  end
  
end