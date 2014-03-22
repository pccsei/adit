onLoad(function() {
    // Custom method to make sure only letters are entered
    jQuery.validator.addMethod("letters_only", function(value, element) {
        return this.optional(element) || /^[-a-zA-Z\s ?()'\/&-\.]+$/i.test(value);
    });

    // Custom method to make sure the zipcode is not all zeros
    jQuery.validator.addMethod('min_digit', function (value, el, param) {
        return value > param;
    });

    // Custom method to make sure the telephone is valid
    jQuery.validator.addMethod("valid_telephone", function(value, element) {
        return this.optional(element) || /^(((17)\s*[-]\s*(\d{4})\s*[-]\s*([1-4]{1}))*|((([1-9][0-9][0-9])?\s*[-]\s*)*([1-9][0-9][0-9])\s*[-]\s*(\d{4})\s*(([eE][xX][tT])\.?\s*(\d{1,4}))*))$/.test(value);
    });

    $("#new_client").validate({
        rules: {
            "client[business_name]": {required: true},
            "client[address]": {required: true},
            "client[city]": {required: true, letters_only: true},
            "client[zipcode]": {required: true, rangelength: [4,5], digits: true, min_digit: 1},
            "client[contact_fname]": {required: true, letters_only: true},
            "client[contact_lname]": {required: true, letters_only: true},
            "client[telephone]": {required: true}
        },
        messages: {
            "client[business_name]": "Please enter the business name.",
            "client[address]": "Please enter the address.",
            "client[city]": "Please enter a valid city.",
            "client[zipcode]": "Please enter a valid zipcode.",
            "client[contact_fname]": "Please enter a first name.",
            "client[contact_lname]": "Please enter a last name.",
            "client[telephone]": "Please enter a telephone number."
        }
    });
    function dState(){
        if ($("#assignClient").is(":enabled"))
            $("#assignClient").prop("disabled", true);
    }

    function eState(enable){
        enable = typeof enable !== 'undefined' ? enable : -1;
        if ($("#assignClient").is(":disabled") && enable != 0)
            $("#assignClient").prop("disabled", false);
    }

    $(function() {

        $('#students').selectable({
            stop:function(event, ui){
                $(event.target).children('.ui-selected').not(':first').removeClass('ui-selected'); // thanks to http://stackoverflow.com/questions/861668/how-to-prevent-multiple-selection-in-jquery-ui-selectable-plugin
            },
            unselected:function(event, ui){
                dState();
            },
            selected:function(event, ui){
                $.get( "more_allowed?school_id=" + ui["selected"].value + "&priority=" + $('#clientPriority').html(),
                    function( data ) {
                        if (data === "true") {
                            $("#studentID").val($('#students .ui-selected').attr('value'));
                            eState(ui["selected"].value);
                            $('#warnTeacher').empty();
                        }
                        else {
                            dState();
                            $('#warnTeacher').html(ui["selected"].innerHTML + " cannot get any more " + $('#clientPriority').html() + " priority clients");
                        }
                    });
            }
        });


        $("#sectionNum").change( function() {
            dState();
            if (this.value != null) {
                $.getJSON("../users/in_section.json?sn=" + this.value,
                    function(json) {
                        $("#students").empty();
                        if (json.length > 0)
                            for (i = 0; i<json.length; i++)
                                $("#students").append("<li class='ui-widget-content clicker' value='" + json[i][0]+"'>"+json[i][2]+", "+json[i][1]+" ("+json[i][0]+")</li>");
                        else
                            $("#students").append("<li id='noAssign' class='ui-widget-content'>"+"There are no students in this section"+"</li>");
                    });
            }
        });

        $("#assignClient").click(function() {
            $("#studentID").val($('#students .ui-selected').attr('value'));
        });


        $(".ui-widget-content").change(function() {
            $("#assignClient").prop("disabled", false);

        });
    });
});