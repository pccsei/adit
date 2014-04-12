//*********************************************************************************************************************/
// Receipts.js - Everything must be wrapped in the onLoad function to handle Turbolinks
//*********************************************************************************************************************/
onLoad(function () {

//*********************************************************************************************************************/
// My Receipts - Release Client
//*********************************************************************************************************************/

    $('.modal').modal({keyboard: true, show: false});
    $(".release_button").click(function () {
        $("#ticket_id").val(this.id);
        $('.modal').modal('show');
    });

    $('.closeModal').click(function () {
        $('.modal').modal('hide');
    });

    $("#body").keyup(function () {
        if ($('#body').val().length > 0)
            $('#switchText').attr('value', "Comment and Release");
        else
            $('#switchText').attr('value', "Release");
    });

//*********************************************************************************************************************/
// Receipts Show Page - Update Client Form
//*********************************************************************************************************************/

    $(".hidden").hide();

    // These three blocks control the show hide when different checkboxes are clicked
    $("#contact").click(function () {
        if ($("#contact").is(':checked')) {
            $("#firstCheck").removeClass("hidden").show();
            $("#timepicker").removeClass("hidden").show();
        }
        else {
            $("#firstCheck").hide();
            $("#presentation").attr('checked', false);
            $("#checkers2").hide();
            $("#saleMade").hide();
            $("#sale").attr('checked', false);
            $("#timepicker").addClass("hidden").hide();
        }

    });

    $("#presentation").click(function () {
        if ($("#presentation").is(':checked')) {
            $("#checkers2").removeClass("hidden").show();
            $("#timepicker").removeClass("hidden").show();
        }
        else {
            $("#checkers2").addClass("hidden").hide();
            $("#saleMade").hide();
            $("#sale").attr('checked', false);
            if ($("#contact").is(':unchecked'))
                $("#timepicker").addClass("hidden").hide();
        }
    });

    $("#sale").click(function () {
        if ($("#sale").is(':checked')) {
            $("#saleMade").removeClass("hidden").show();
            $("#timepicker").removeClass("hidden").show();
        }
        else {
            $("#saleMade").addClass("hidden").hide();
            if ($("#contact").is(':unchecked') && $("#presentation").is(':unchecked'))
                $("#timepicker").addClass("hidden").hide();
        }
    });

    $('#user_action_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT", maxDate: new Date });

    // Adds the other option textbox when selecting a page size option
    $('#page').change(function () {
        if ($("#page option:selected").text() == "Other") $('#otherSize').removeClass("hidden").show();
        else $('#otherSize').addClass('hidden').hide();
    });

    $('#otherSize').keyup(function () {
        var v = eval(this.value);
        if (isFloat(v) || isInteger(v)) {
            $('#o').val(v.toFixed(2));
            //$('#page').val(v); // Moves dropdown to appropriate value if it is already provided
        }
        else $('#0').val(null);
    });

    // function isFloat and isInteger from http://stackoverflow.com/questions/3885817/how-to-check-if-a-number-is-float-or-integer
    function isFloat(n) {
        return n === +n && n !== (n | 0);
    }

    function isInteger(n) {
        return n === +n && n === (n | 0);
    }

    // Initialize the dataTable located in the _action_table partial
    onLoad(function () {
        var table = $('.action_table').dataTable({
            "bPaginate": false,
            "bFilter": false,
            "bSort": false,
            "iCookieDuration": 60,
            "bStateSave": false,
            "bAutoWidth": false,
            "bInfo": false,
            "bProcessing": true,
            "bRetrieve": true,
            "bJQueryUI": true,
            "fnInitComplete": function () {
                this.css("visibility", "visible");
            },
            "fnPreDrawCallback": $(".autoHide").hide()
        }, $(".defaultTooltip").tooltip({
            'selector': '',
            'placement': 'left',
            'container': 'body'
        }));
    });

//*********************************************************************************************************************/
// Receipts Show Page Validation
//*********************************************************************************************************************/

    // Custom validation to make sure the number entered is a float with two decimals only
    jQuery.validator.addMethod('fraction_decimal', function (value, element) {
        return this.optional(element) ||
            /^([1-3]|([1-9]([0-9])?[/][1-9]([0-9])?)|(([0-2]*\.([0-9][1-9]|[1-9][0-9]))|([1-2](\.\d{1,2}))))$/i.test(value);
    });
    // Custom validation to make sure the number entered is a float with two decimals only
    jQuery.validator.addMethod('decimal', function (value, element) {
        return this.optional(element) ||
            /^((\d)*|(([0-9]+\.([0-9]*[1-9]+|[1-9]+[0-9]*))|([1-9]+[0-9]*(\.\d{1,2}))))$/i.test(value);
    });

    // Custom method to make sure the leading number is not zero
    jQuery.validator.addMethod("leading_zero", function (value, element) {
        return this.optional(element) ||
            /^(([1-9]+[0-9]*(\.(\d)*)?)|([0]+\.([0-9]*[1-9]+|[1-9]+[0-9]*)))$/.test(value);
    });

    // Custom validation to make sure the datetime matches what we need
    jQuery.validator.addMethod("valid_format", function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/]\d{2}[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the datetime matches what we need
    jQuery.validator.addMethod("valid_year", function (value, element) {
        return this.optional(element) ||
            /^([2-9]\d{3}[/]\d{2}[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the datetime matches what we need
    jQuery.validator.addMethod("valid_month", function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/](([1][0-2])|([0][1-9]))[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the datetime matches what we need
    jQuery.validator.addMethod("valid_day", function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/]\d{2}[/](([0][1-9])|([1-2][0-9])|(3[0-1]))\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the price and page are not all zeros
    jQuery.validator.addMethod('min_digit', function (value, el, param) {
        return value >= param;
    });

    $("#new_action").validate({
        rules: {
            "price": {required: true, decimal: true, leading_zero: true, min_digit: .01, max: 1500, maxlength: 7},
            "otherSize": {required: true, fraction_decimal: true},
            "user_action_time": {required: true, date: true, valid_format: true, valid_year: true, valid_month: true, valid_day: true},
            "comment": {maxlength: 250}
        },
        messages: {
            "price": {
                required: "Please enter a valid price (30 or 30.00).",
                decimal: "Only a number with 0-2 decimal places (no commas).",
                leading_zero: "The first number cannot be zero.",
                min_digit: "Price cannot be all zero.",
                max: "The price should not be higher than 1500 dollars.",
                maxlength: "Cannot be more than six digits long."
            },
            "otherSize": {
                required: "Please enter an ad size (.25 or 1.5).",
                fraction_decimal: "Can be a fraction or a number with 0-2 decimal places (both non-zero)."
            },
            "user_action_time": {
                required: "Please enter in the date and time when you did this.",
                date: "The date is incorrect",
                valid_year: "Please select a year after 2000.",
                valid_month: "Please select a valid month.",
                valid_day: "Please select a valid day.",
                valid_format: "Should match format YYYY/MM/DD HH:MM AM/PM."
            },
            "comment": "The maximum length for a comment is 250 characters."
        }
    });

//*********************************************************************************************************************/
//                                   My Receipts - Release Client Validation
//*********************************************************************************************************************/
    $("#release_client").validate({
        rules: {
            "body": {maxlength: 250}
        },
        messages: {
            "body": "&nbsp;&nbsp;The maximum length for a comment is 250 characters."
        }
    });
});

