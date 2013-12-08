require 'test_helper'
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :users
  
  test "users browse allowed pages" do
    # Define who the user is
    teacher = assign(:teacher)
    student_rep = assign(:student_rep)
    student_manager = assign(:student_manager)
    
    # All users to visit all clients
    teacher.browses_all_clients
    student_rep.browses_all_clients
    student_manager.browses_all_clients
    
    # Teacher and student manager only to visit manage section
    teacher.browses_manage_section
    student_rep.browses_manage_section
    student_manager.browses_manage_section
    
    # Teacher and student manager only to visit a specific student in manage section
    teacher.browses_manage_section_student
    student_rep.browses_manage_section_student
    student_manager.browses_manage_section_student
    
    # Teacher only to edit manage section
=begin    teacher.browses_manage_section_edit
    student_rep.browses_manage_section_edit
    student_manager.browses_manage_section_edit
    
    # Teacher only to visit project
    teacher.browses_project
    student_rep.browses_project
    student_manager.browses_project
    
    # Teacher only to visit project show
    teacher.browses_project_show
    student_rep.browses_project_show
    student_manager.browses_project_show
    
    # Teacher only to visit project new
    teacher.browses_project_new
    student_rep.browses_project_new
    student_manager.browses_project_new
    
    # Teacher only to visit project edit
    teacher.browses_project_edit
    student_rep.browses_project_edit
    student_manager.browses_project_edit
    
    # All users to visit my clients
    teacher.browses_my_clients
    student_rep.browses_my_clients
    student_manager.browses_my_clients
    
    # Teacher and student manager only to visit reports
    teacher.browses_reports
    student_rep.browses_reports
    student_manager.browses_reports
    
    # Teacher and student manager only to visit reports of sale log
    teacher.browses_reports_sales
    student_rep.browses_reports_sales
    student_manager.browses_reports_sales
    
    # Teacher and student manager only to visit reports of activity log
    teacher.browses_reports_activity
    student_rep.browses_reports_activity
    student_manager.browses_reports_activity
    
    # Teacher and student manager only to visit reports of student summary
    teacher.browses_reports_students
    student_rep.browses_reports_students
    student_manager.browses_reports_students
    
    # All users to view pending clients
    teacher.browses_pending_clients
    student_rep.browses_pending_clients
    student_manager.browses_pending_clients
    
    # All users to view pending clients show
    teacher.browses_pending_clients_show
    student_rep.browses_pending_clients_show
    student_manager.browses_pending_clients_show
    
    # All users to view pending clients new
    teacher.browses_pending_clients_new
    student_rep.browses_pending_clients_new
    student_manager.browses_pending_clients_new
    
    # All users to view pending clients edit
    teacher.browses_pending_clients_edit
    student_rep.browses_pending_clients_edit
=end    student_manager.browses_pending_clients_edit
  end
  
  private
    module CustomDsl
      def browses_all_clients
        get ""
        assert_response :success
        assigns(:clients)
      end
      def browses_manage_section
        get "/users"
        assert_response :success
      end
      def browses_manage_section_student
        get "/users/1"
        assert_response :success
      end
=begin      def browses_manage_section_edit
        get "/users/1/edit"
        assert_response :success
      end
      def browses_project
        get "/projects"
        assert_response :success
      end
      def browses_project_show
        get "/projects/1"
        assert_response :success
      end
      def browses_project_new
        get "/projects/new" 
        assert_response :success
      end
      def browses_project_edit
        get "/projects/1/edit"
        assert_response :success
      end
      def browses_my_clients
        get "/receipts"
        assert_response :success
      end
      def browses_reports
        get "/reports"
        assert_response :success
      end
      def browses_reports_sales
        get "/reports/sales_log"
        assert_response :success
      end
      def browses_reports_activity
        get "/reports/activity_log"
        assert_response :success
      end
      def browses_reports_students
        get "/reports/student_summary"
        assert_response :success
      end
      def browses_pending_clients
        get "/pending_clients"
        assert_response :success
      end
      def browses_pending_clients_show
        get "/pending_clients/1"
        assert_response :success
      end
      def browses_pending_clients_new
        get "/pending_clients/new"
        assert_response :success
      end
      def browses_pending_clients_edit
        get "/pending_clients/1/edit"
        assert_response :success
=end      end
    end
    
    def assign(user)
      open_session do |session|
        session.extend(CustomDsl)
        u = users(user)
      end
    end
end