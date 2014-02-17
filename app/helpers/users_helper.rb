module UsersHelper
  
  def current_year
    Time.now.year 
  end
  
  def next_year
    Time.now.year + 1
  end
end
