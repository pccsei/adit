# Be sure to restart your server when you modify this file.

# I think this allows for xls conversion. This is part of the steps on 
# http://railscasts.com/episodes/362-exporting-csv-and-excel for making
# our work possible to convert to excel. James Mulvihill
Mime::Type.register "application/xls", :xls

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
