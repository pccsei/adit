onLoad(function() {
  
    /* Jquery to validate user input */
  
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
    
    /* Functions */
    function dState(){ if ($("#assignClient").is(":enabled")) $("#assignClient").prop("disabled", true); }

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

    $('#toggleRow').hide();
    $('#client_business_name').focus(function(){ $('#toggleRow').show(); });
    $('.hideClients').focus(function(){ $('#toggleRow').hide(); });   
    
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
    
    var priorities = ['high', 'medium', 'low'];
    var index      = 0; 
    var ascFlag    = true;
    var descFlag   = true;  
    
    var priorityArray = {};
    priorityArray['High']   =-1;
    priorityArray['Medium'] = 0;
    priorityArray['Low']    = 1;
    
    function updatePriorityArray(){
      priorityArray['High']   = ((priorityArray['High']   + 2) % 3) - 1;
      priorityArray['Medium'] = ((priorityArray['Medium'] + 2) % 3) - 1;
      priorityArray['Low']    = ((priorityArray['Low']    + 2) % 3) - 1;
    }
  
  // This function enable the datatable on the tickets page to cycle through priorities.
  jQuery.fn.dataTableExt.oSort['priority-asc'] = function(x,y) {
  
    if (descFlag) {
      index++;
      index   %= priorities.length;
      ascFlag  = true;
      descFlag = false;   
      updatePriorityArray();
      console.log("asc called");
      console.log("pushing " + priorities[index] + " to the top");
    }
    var currentPriority = priorities[index];
    
    // This strips out the span tags I added to the td. - Rob
    x = $(x).text();
    y = $(y).text();

    if      (x == (currentPriority) && y == (currentPriority)) return  0;
    else if (x == (currentPriority))                           return -1;
    else if (y == (currentPriority))                           return  1;
    else  return ((priorityArray[x] < priorityArray[y]) ?  1 : ((priorityArray[x] > priorityArray[y]) ? -1 : 0 ));
  };
  
  // This one too
  jQuery.fn.dataTableExt.oSort['priority-desc'] = function(x,y) {
    if (ascFlag) {
      index++;
      index   %= priorities.length;
      ascFlag  = false;
      descFlag = true;   
      updatePriorityArray(); 
      console.log("desc called");
      console.log("pushing " + priorities[index] + " to the top");
      var nextIndex = index;
    }   
    var currentPriority = priorities[index];
        
    // This strips out the span tags I added to the td. - Rob
    x = $(x).text();
    y = $(y).text();

    if (x == (currentPriority) && y == (currentPriority))
      return 0;
    else if (x == (currentPriority))
      return -1;
    else if (y == (currentPriority)) 
      return 1;
    else
      return ((priorityArray[x] < priorityArray[y]) ?  1 : ((priorityArray[x] > priorityArray[y]) ? -1: 0 ) );
  };    
      
  var table =  $('.assign_table').dataTable({
      "aoColumns" : [{ "bSortable": true }, {"sType": "priority" }, null, null, null, null, null, null, null, null, null, null, null],
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

  /* Actions done on page load */
  table.fnSort( [ [1,'asc'] ] );
	populate($('#currentSection').html());

  //table.fnSort( [ [2,'asc'] ] );
    
  // Creates the list populated by the students as a selectable list.
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

  return table;  
});