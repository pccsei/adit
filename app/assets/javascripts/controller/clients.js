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
        return this.optional(element) || /^((((([(])?[1-9][0-9][0-9]([)])?)?\s*([-])?\s*)*([1-9][0-9][0-9])\s*([-])?\s*(\d{4})\s*)?(([eE][xX][tT])\.?\s*(\d{1,6}))?)$/.test(value);
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
            "client[zipcode]": {required: true, digits: true, rangelength: [4,5], min: 1},
            "client[contact_fname]": {letters_only: true},
            "client[contact_lname]": {letters_only: true},
            "client[telephone]": {required: true, valid_telephone: true},
            "client[email]": {valid_email: true}
        },
        messages: {
            "client[business_name]": "Please enter the business name.",
            "client[address]": "Please enter the address.",
            "client[city]": {
            	required: "Please enter a city",
            	letters_only: "You entered an invalid character(s)."
            },
            "client[zipcode]": {
            	required: "Please enter a zipcode.",
            	digits: "Can only be digits (numbers 0-9).",
            	rangelength: "Needs to be a range of 4-5 digits long.",
            	min: "Cannot be all zeros."
            },
            "client[contact_fname]": "You entered an invalid character(s).",
            "client[contact_lname]": "You entered an invalid character(s).",
            "client[telephone]": {
            	required: "Please enter a telephone number.",
            	valid_telephone: "Must be 7 or 10 (if using area code) digits and \"ext.\" followed with range of 1-6 digits (if using extension)."
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
    
    function populate(section){
    	if (section != null) {
            $.getJSON("../users/in_section.json?sn=" + section,
                function(json) {
                    $("#students").empty();
                    if (json.length > 0)
                        for (i = 0; i<json.length; i++)
                            $("#students").append("<li class='clickable ui-widget-content clicker' value='" + json[i][0]+"'>"+json[i][2]+", "+json[i][1]+" ("+json[i][0]+")</li>");
                    else
                        $("#students").append("<li id='noAssign' class='clickable ui-widget-content'>"+"There are no students in this section"+"</li>");
                });
        }    	
    }

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

    $(".sectionNum").click( function() {    	
        dState();
        populate($(this).text());
    });


    $("#assignClient").click(function() {
        $("#studentID").val($('#students .ui-selected').attr('value'));
    });


    $(".ui-widget-content").change(function() {
        $("#assignClient").prop("disabled", false);

    });
    
    $("#client_business_name").bind( "keydown", function( event ) {
        $( "#client_business_name" ).attr('value', "test") 
    });
    
	populate($('#currentSection').html());
    
    var table =  $('.assign_table').dataTable({
        "bPaginate" : false,
        "iCookieDuration": 60,
        "bStateSave": false,
        "bAutoWidth": false,
        "bScrollAutoCss": true,
        "bProcessing": true,
        "bRetrieve": true,
        "bJQueryUI": true,
        "sDom": '<"H"CTrf>t<"F"lip>',
        "sScrollXInner": "110%",
        "fnInitComplete": function() {
            this.css("visibility", "visible");
        },
        "fnPreDrawCallback": $(".autoHide").hide()
    }, $(".defaultTooltip").tooltip({
        'selector': '',
        'placement': 'left',
        'container': 'body'
    }));

    $('table.assign_table').each(function(i,table) {
        $('<div style="width: 100%; overflow: auto"></div>').append($(table)).insertAfter($('#' + $(table).attr('id') + '_wrapper div').first());
    });

    table.fnSort( [ [1,'asc'] ] );

    return table;
    
});