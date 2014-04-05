//*********************************************************************************************************************/
// Projects.js - Everything must be wrapped in the onLoad function to handle Turbolinks
//*********************************************************************************************************************/
onLoad(function () {

//*********************************************************************************************************************/
// Projects new/edit  - Everything must be wrapped in the onLoad function to handle Turbolinks
//*********************************************************************************************************************/

    $('#project_tickets_open_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT"});
    $('#project_tickets_close_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT" });


    // These three code blocks make the priorities choices logical
    $('#project_max_clients').change(function (s) {
        var high = $('#project_max_high_priority_clients')[0];
        var medium = $('#project_max_medium_priority_clients')[0];
        var low = $('#project_max_low_priority_clients')[0];
        var selected_index = s.target.selectedIndex;
        if (selected_index > 0) {
            high.selectedIndex = Math.min(high.selectedIndex, selected_index);
            medium.selectedIndex = Math.min(medium.selectedIndex, selected_index);
            low.selectedIndex = Math.min(low.selectedIndex, selected_index);
        }
    });

    function update_project_max_clients(s) {
        var clients = $('#project_max_clients')[0];
        var selected_index = clients.selectedIndex;
        if (selected_index > 0) {
            clients.selectedIndex = Math.max(selected_index, s.target.selectedIndex);
        }
    }
    $('#project_max_high_priority_clients').change(update_project_max_clients);

    $('#project_max_medium_priority_clients').change(update_project_max_clients);
    $('#project_max_low_priority_clients').change(update_project_max_clients);
});
