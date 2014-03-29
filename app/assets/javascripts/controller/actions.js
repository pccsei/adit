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

    $('#foo_user_action_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT", maxDate: new Date });

	// Custom validation to make sure the number entered is a float with two decimals only
    jQuery.validator.addMethod("floating_number", function(value, element) {
        return this.optional(element) || /^(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d{1,2})?$/i.test(value);
    });
    
    // Custom validation to make sure the price and page are not all zeros
    jQuery.validator.addMethod('min_digit', function (value, el, param) {
        return value >= param;
    });

    $("#new_foo").validate({
        rules: {
            "price": {required: true, floating_number: true, min_digit: .01},
            "page": {required: true, floating_number: true, min_digit: .01},
            "foo[comment]": {required: true},
            "foo[user_action_time]": {required: true, date: true }
        },
        messages: {
            "price": {
            	required: "Please enter a valid price (30 or 30.00).",
            	floating_number: "Can only be a number with 0-2 decimal digits (30 or 30.00).",
            	min_digit: "The value cannot be all zeros."
            },
            "page": {
            	required: "Please enter a page size (.25 or 1.5).", 
            	floating_number: "Can only be a number with 0-2 decimal digits (.5 or .50).",
            	min_digit: "The value cannot be all zeros."
            },
            "foo[comment]": "If you have a comment, then please enter it.",
            "foo[user_action_time]": "Please enter in the date and time when you did this."
        }
    });
    
    $('#foo_user_action_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT", minDate: new Date });
    
});