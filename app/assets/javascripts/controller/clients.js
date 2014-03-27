onLoad(function() {
    // Custom method to make sure only letters are entered
    jQuery.validator.addMethod("letters_only", function(value, element) {
        return this.optional(element) || /^[-a-zA-Z\s ?()'\/\\&-\.]+$/i.test(value);
    });

    // Custom method to make sure the zipcode is not all zeros
    jQuery.validator.addMethod('min_digit', function (value, el, param) {
        return value >= param;
    });

    // Custom method to make sure the telephone is valid
    jQuery.validator.addMethod("valid_telephone", function(value, element) {
        return this.optional(element) || /^((((([(])?[1-9][0-9][0-9]([)])?)?\s*([-])?\s*)*([1-9][0-9][0-9])\s*([-])?\s*(\d{4})\s*)?(([eE][xX][tT])\.?\s*(\d{1,7}))?)$/.test(value);
    });
    
    // Custom method to make sure the zipcode is valid
    jQuery.validator.addMethod("valid_zipcode", function(value, element) {
        return this.optional(element) || /^(\d{4,5}([-]\d{4})?)$/.test(value);
    });
    
    // Custom method to make sure the email is valid
    jQuery.validator.addMethod("valid_email", function(value, element) {
        return this.optional(element) || /^([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/.test(value);
    });

    $("#new_client").validate({
        rules: {
            "client[business_name]": {required: true},
            "client[address]": {required: true},
            "client[city]": {required: true, letters_only: true},
            "client[zipcode]": {required: true, valid_zipcode: true, rangelength: [4,11], min_digit: (0001)},
            "client[contact_fname]": {letters_only: true},
            "client[contact_lname]": {letters_only: true},
            "client[telephone]": {required: true, valid_telephone: true},
            "client[email]": {valid_email: true}
        },
        messages: {
            "client[business_name]": "Please enter the business name.",
            "client[address]": "Please enter the address.",
            "client[city]": {
            	required: "Please enter a city.",
            	letters_only: "Only letters and punctuation allowed."
            },
            "client[zipcode]": {
            	required: "Please enter a zipcode.",
            	valid_zipcode: "Can only be digits (numbers 0-9).",
            	rangelength: "Needs to be a range of 4-5 digits long (and -#### if using the 4 digit zip code extension).",
            	min_digit: "Cannot be all zeros."
            },
            "client[contact_fname]": "Only letters and punctuation allowed.",
            "client[contact_lname]": "Only letters and punctuation allowed.",
            "client[telephone]": {
            	required: "Please enter a telephone number.",
            	valid_telephone: "Must be 7 or 10 (if using area code) digits and \"ext.\" followed with range of 1-7 digits (if using extension)."
            },
            "client[email]": "Must be in a standard email format."
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