module TicketsHelper
  
  
  def tooltipify(string, cellWidth = 12, className = "defaultTooltip") # cell width was arbitrarily chosen  
    if string.length > cellWidth
      "<span class='#{className}' data-placement='left' data-toggle='tooltip' data-original-title='#{string}'>" << string[0..cellWidth - 3] << "..." << "</span>"
      #'<span class="right" data-toggle="tooltip" data-placement="top" title="Tooltip on top">Tooltip on right</span>'
    else 
       string
    end 
  end
   
  
end
