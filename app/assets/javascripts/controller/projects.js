onLoad(function() {

    $('#project_tickets_open_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT"});
    $('#project_tickets_close_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT" });

    $("#new_project").validate({
        rules: {
            "project[tickets_open_time]": {required: true, date: true},
            "project[tickets_close_time]": {required: true, date: true}

        },
        messages: {
            "project[tickets_open_time]": "Please select an open time.",
            "project[tickets_close_time]": "Please select a close time."
        }
    });
    $('#project_max_clients').change(function(s) {
        var high = $('#project_max_high_priority_clients')[0];
        var medium = $('#project_max_medium_priority_clients')[0];
        var low = $('#project_max_low_priority_clients')[0];
        high.selectedIndex = Math.min(high.selectedIndex, s.target.selectedIndex);
        medium.selectedIndex = Math.min(medium.selectedIndex, s.target.selectedIndex);
        low.selectedIndex = Math.min(low.selectedIndex, s.target.selectedIndex);
    });
    function update_project_max_clients(s) {
        var clients = $('#project_max_clients')[0];
        clients.selectedIndex = Math.max(clients.selectedIndex, s.target.selectedIndex);
    }
    $('#project_max_high_priority_clients').change(update_project_max_clients);
    $('#project_max_medium_priority_clients').change(update_project_max_clients);
    $('#project_max_low_priority_clients').change(update_project_max_clients);
});