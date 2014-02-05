class ReportsController < ApplicationController
  
  def sales
    
  end
  
  # GET reports/student_summary
  def student_summary
       @receipts = Receipt.selected_project_receipts(get_selected_project)
  end
  
  # GET reports/team_summary
  def team_summary
    
  end
  
  def activity
    
  end
  
end