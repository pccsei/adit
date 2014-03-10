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

});