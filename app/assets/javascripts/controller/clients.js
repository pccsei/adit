//*********************************************************************************************************************/
// Clients.js - Everything must be wrapped in the onLoad function to handle Turbolinks
//*********************************************************************************************************************/

onLoad(function() {
  
    // Custom method to make sure only letters are entered
    jQuery.validator.addMethod("letters_only", function(value, element) {
        return this.optional(element) || /^[-a-zA-Z\s ?()'\/\\&-\.;:]+$/i.test(value);
    });

    // Custom method to make sure the zipcode is not all zeros
    jQuery.validator.addMethod('min_digit', function (value, el, param) {
        return value >= param;
    });

    // Custom method to make sure the telephone is valid
    jQuery.validator.addMethod("valid_telephone", function(value, element) {
        return this.optional(element) || /^((((([(])?[1-9]\d{2}([)])?)?\s*([-])?\s*)?([1-9]\d{2})\s*([-])?\s*(\d{4})\s*)?(([eE][xX][tT])\.\s*([1-9]\d{1,6}))?)$/.test(value);
    });
    
    // Custom method to make sure the zipcode is valid
    jQuery.validator.addMethod("valid_zipcode", function(value, element) {
        return this.optional(element) || /^(\d{4,5})$/.test(value);
    });
    
    // Custom method to make sure the leading number is not zero
    jQuery.validator.addMethod("leading_zero", function(value, element) {
        return this.optional(element) || /^([1-9]+(\d)*)$/.test(value);
    });
    
    // Custom method to make sure the email is valid
    jQuery.validator.addMethod("valid_email", function(value, element) {
        return this.optional(element) || /^([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/.test(value);
    });

    $("#clients").validate({
        rules: {
            "client[business_name]": {required: true, maxlength: 65},
            "client[address]": {required: true, maxlength: 80},
            "client[city]": {required: true, letters_only: true, maxlength: 30},
            "client[zipcode]": {required: true, valid_zipcode: true, leading_zero: true},
            "client[contact_fname]": {letters_only: true, maxlength: 30},
            "client[contact_lname]": {letters_only: true, maxlength: 30},
            "client[telephone]": {required: true, valid_telephone: true},
            "client[email]": {valid_email: true, maxlength: 35},
      		"client[comment]": {maxlength: 250}
        },
        messages: {
            "client[business_name]": {
        		required:  "Please enter the business name.",
        		maxlength: "The maximum length for a business name is 65 characters."
      		},
            "client[address]": {
        		required:  "Please enter the address.",
        		maxlength: "The maximum length for an address is 80 characters."
      		},
            "client[city]": {
              	required:     "Please enter a city.",
              	letters_only: "Will only accept letters and punctuation.",
        		maxlength:    "The maximum length for a city is 30 characters."
            },
            "client[zipcode]": {
              	required:      "Please enter a zipcode.",
              	valid_zipcode: "Can either be 4 or 5 digits long.",
              	leading_zero: "First number cannot be zero."
            },
            "client[contact_fname]": {
        		letters_only: "Will only accept letters and punctuation.",
        		maxlength:    "The maximum length for a first name is 30 characters."
      		},
            "client[contact_lname]": {
        		letters_only: "Will only accept letters and punctuation.",
        		maxlength:    "The maximum length for a last name is 30 characters."
      		},
            "client[telephone]": {
              	required: "Please enter a telephone number.",
              	valid_telephone: "Must be 7 or 10 digits. For extension, use \"ext.\" followed by 1-7 digits."
            },
            "client[email]": {
        		valid_email: "Must be in a standard email format.",
        		maxlength:   "The maximum length for an email is 35 characters."
      		},
      		"client[comment]": {
        		maxlength:   "The maximum length for a comment is 250 characters."
      		}
        }
    });
  
//*********************************************************************************************************************/
// Clients Show Assign For - Allows the teacher to assign a client to a student.
//*********************************************************************************************************************/  
  
  // Disables the assign button.
  function dState(){ if ($("#assignClient").is(":enabled")) $("#assignClient").prop("disabled", true); }

  // Enables the assign button 
  function eState(enable){
      enable = typeof enable !== 'undefined' ? enable : -1;
      if ($("#assignClient").is(":disabled") && enable != 0)
          $("#assignClient").prop("disabled", false);
  }
  
  // Given a section number, the function populates the student list with data from the server of all students in that section.
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

  // Makes the student list a selectable list via jQuery ui.
  $('#students').selectable({
    stop:function(event, ui){
      $(event.target).children('.ui-selected').not(':first').removeClass('ui-selected'); // thanks to http://stackoverflow.com/questions/861668/how-to-prevent-multiple-selection-in-jquery-ui-selectable-plugin
    },
    unselected:function(event, ui){
      dState();
    },
    selected:function(event, ui){
      $.get( "more_allowed?school_id=" + ui["selected"].value + "&priority=" + $('#clientPriority').html(),
        function(data) {
          if (data === "true") {
            $("#studentID").val($('#students .ui-selected').attr('value'));
            eState(ui["selected"].value);
            $('#warnTeacher').empty();
          }
          else {
            dState();
            $('#warnTeacher').html(ui["selected"].innerHTML + " has the maximum number of clients.");
          }
        });
    }
  });
  
  // Sets the value of the hidden input element for submission to the server. 
  $("#assignClient").click(function() {
      $("#studentID").val($('#students .ui-selected').attr('value'));
  });

  // Disables the button when the teacher clicks away from a valid student that was selected. The button will become active
  // again once the page knows the newly selected student is allowed to have more clients.  
  $(".ui-widget-content").change(function() {
      $("#assignClient").prop("disabled", false);
  });

  // Repopulates the student list when the teacher selects another section number from the dropdown.
  $(".sectionNum").click( function() {    	
      dState();
      populate($(this).text());
  });

  // Populates the student list with whatever section the teacher happens to have been viewing.
  populate($('#currentSection').html());

//*********************************************************************************************************************/
// Clients New - Users can manually add a client to the database
//*********************************************************************************************************************/
  var $rows = $('#businessNames tr');
  $('#client_business_name').keyup(function() {
    var val = '^(?=.*\\b' + $.trim($(this).val()).split(/\s+/).join('\\b)(?=.*\\b') + ').*$',
        reg = RegExp(val, 'i'),
        text;

    $rows.show().filter(function() {
        text = $(this).text().replace(/\s+/g, ' ');
        return !reg.test(text);
    }).hide();
  });
   
  // Shows the list of pre-existing clients when the user goes to enter the name of a new business 
  $('#client_business_name').focus(function(){ $('#toggleRow').show(); });
  
  // Hides the list of pre-existing businesses once the user has moved on from typing the business name
  $('.hideClients').focus(function(){ $('#toggleRow').hide(); });   
  
  // Hides the list of pre-existing businesses
  $('#toggleRow').hide();
  
//*********************************************************************************************************************/
// Clients Index - Lists all the clients in the database that are accessible to this project.
//*********************************************************************************************************************/
  
  // Overrides the default column sorting for toggling through high, medium, low priorities. The code is in application.js
  overridePrioritySort();
      
  // Create the datatable    
  var table =  $('.assign_table').dataTable({
      "aoColumns" : [{ "bSortable": true }, {"sType": "priority" }, null, null, null, null], //stype:priority allows the override to work on this column
      "aaSorting" : [[2, 'asc']],
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

  // Enables scrolling - very nice feature. Without it, the columns do not align.
  $('table.assign_table').each(function(i,table) {
      $('<div style="width: 100%; overflow: auto"></div>').append($(table)).insertAfter($('#' + $(table).attr('id') + '_wrapper div').first());
  });

  return table;  
});