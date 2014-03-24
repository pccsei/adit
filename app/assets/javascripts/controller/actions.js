onLoad(function() {

    $(".hidden").hide();


    $("#presentation").click(function () {
        if ($("#presentation").is(':checked'))
        {
            $("#checkers2").removeClass("hidden").show();
        }
        else
        {
            $("#checkers2").addClass("hidden").hide();
            $("#saleMade").hide();
            $("#sale").attr('checked', false);
        }
    });

    $("#sale").click(function () {
        if ($("#sale").is(':checked'))
        {
            $("#saleMade").removeClass("hidden").show();
        }
        else
        {
            $("#saleMade").addClass("hidden").hide();
        }
    });

    $("#comments").click(function () {
        if ($("#comments").is(':checked'))
        {
            $("#justComment").removeClass("hidden").show();
        }
        else
        {
            $("#justComment").addClass("hidden").hide();
        }
    });

    $('#foo_user_action_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT", maxDate: new Date });

    jQuery.validator.addMethod("floating_number", function(value, element) {
        return this.optional(element) || /^(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/i.test(value);
    });

    $("#new_foo").validate({
        rules: {
            "price": {min: 1, required: true, floating_number: true },
            "foo[comment]": {required: true},
            "foo[user_action_time]": {required: true, date: true }
        },
        messages: {
            "price": "Please enter a valid price (30 or 30.00).",
            "foo[comment]": "If you have a comment, then please enter it.",
            "foo[user_action_time]": "Please enter in when you did this."
        }
    });
    
    $('#foo_user_action_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT", minDate: new Date });
});