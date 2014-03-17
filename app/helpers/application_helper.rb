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
  
  
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}
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
  
end