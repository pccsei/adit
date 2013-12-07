require 'test_helper'
 
class TeacherFlowsTest < ActionDispatch::IntegrationTest
  fixtures :users
  
  test "browse different tabs" do
    # Define who the user is
    teacher = assign(:teacher)
    student_rep = assign(:student_rep)
    student_manager = assign(:student_manager)
    
    # All users go to all clients
    teacher.browses_all_clients
    student_rep.browses_all_clients
    student_manager.browses_all_clients
    
    # Teacher and student manager visit manage section
  end
  
  private
    module CustomDsl
      def browses_all_clients
        get "/"
        assert_response :success
      end
      
      def browses_manage_section
        get "/users"
        assert_response :success
      end
    end
    
    def assign(user)
      open_session do |session|
        session.extend(CustomDsl)
        u = users(user)
      end
    end
end