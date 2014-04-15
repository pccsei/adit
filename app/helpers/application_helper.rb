# Everything that is written in the Application Helper is available on all the views
module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ad It"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  # Creates a span that can be made into a tooltip if the string passed in is longer than specified. Otherwise, just returns the string.
  # You must call $.(".defaultTooltip").tooltip() on the page for the tooltip to show
  def tooltipify(string, cellWidth = 12, className = "defaultTooltip") # cell width was arbitrarily chosen  
    if string
      if string.length > cellWidth
        ("<span class='#{className}' data-placement='left' data-toggle='tooltip' data-original-title='#{string}'>" << string[0..cellWidth - 3] << "..." << "</span>").html_safe
      else 
         string
      end         
    end
  end
  
  # Makes sure a value does not go below zero
  def zeroMin(val)
    return val < 0 ? 0 : val
  end
  
end