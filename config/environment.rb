# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
WhiteCollar::Application.initialize!

TEACHER         = 3         # Teacher role
STUDENT         = 1         # Student role
NA              = -1        # No client restriction
LAST_NON_ADIT_ARROW_YEAR    = 2013  
                            # Last year of the arrow project without Adit
LAST_NON_ADIT_CALENDAR_YEAR = 2013 
                            # Last year of the calendar project without Adit