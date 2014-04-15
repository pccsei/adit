module UsersHelper

  # Returns current year  
  def current_year
    Time.now.year 
  end
  
  # Returns next year
  def next_year
    Time.now.year + 1
  end
end
