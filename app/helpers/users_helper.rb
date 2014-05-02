module UsersHelper

  # Returns current year  
  def current_year
    Time.now.year 
  end
  
  # Returns dropdown value in main dropdown
  def bonus_selected(bonus_type)
    if bonus_type
      return 'Assign Bonus Points'
    else
      return false
    end
  end
  
  # Returns dropdown for bonus type
  def bonus_type_selected(bonus_type)
    if bonus_type
      return bonus_type
    else
      return false
    end
  end
  
  # Returns next year
  def next_year
    Time.now.year + 1
  end
end
