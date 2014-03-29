onLoad(function() {  
  $('.modal').modal({keyboard: true, show: false});
  $(".release_button").click(function(){
    $("#ticket_id").val(this.id);
  	$('.modal').modal('show');  	
  });
  
  $('.closeModal').click(function(){
  	$('.modal').modal('hide');
  });  
  
  $("#body").keyup(function(){
    if ($('#body').val().length > 0)
      $('#switchText').attr('value', "Comment and Release");
    else
      $('#switchText').attr('value', "Release");
  });

    $(".hidden").hide();

    $("#contact").click(function () {
    	if ($("#contact").is(':checked'))
    	{
    		$("#firstCheck").removeClass("hidden").show();
    		$("#timepicker").removeClass("hidden").show();
    	}
    	else
    	{
    	    $("#firstCheck").hide();
    	    $("#presentation").attr('checked', false);
    	    $("#checkers2").hide();
    	    $("#saleMade").hide();
            $("#sale").attr('checked', false);
            $("#timepicker").addClass("hidden").hide();
        }
        
    });
    
    $("#presentation").click(function () {
        if ($("#presentation").is(':checked'))
        {
            $("#checkers2").removeClass("hidden").show();
            $("#timepicker").removeClass("hidden").show();
        }
        else
        {
            $("#checkers2").addClass("hidden").hide();
            $("#saleMade").hide();
            $("#sale").attr('checked', false);
            if ($("#contact").is(':unchecked'))
               $("#timepicker").addClass("hidden").hide();
        }
    });

    $("#sale").click(function () {
        if ($("#sale").is(':checked'))
        {
            $("#saleMade").removeClass("hidden").show();
            $("#timepicker").removeClass("hidden").show();
        }
        else
        {
            $("#saleMade").addClass("hidden").hide();
            if ($("#contact").is(':unchecked') && $("#presentation").is(':unchecked'))
               $("#timepicker").addClass("hidden").hide();
        }
    });

    $('#user_action_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT", maxDate: new Date });

	// Custom validation to make sure the number entered is a float with two decimals only
    jQuery.validator.addMethod("floating_number", function(value, element) {
        return this.optional(element) || /^(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d{1,2})?$/i.test(value);
    });
    
    // Custom validation to make sure the price and page are not all zeros
    jQuery.validator.addMethod('min_digit', function (value, el, param) {
        return value >= param;
    });

       
    $("#new_action").validate({
        rules: {
            "price": {required: true, floating_number: true, min_digit: .01 },
            "otherSize": {required: true, floating_number: true, min_digit: .01},
            "user_action_time": {required: true, date: true }
        },
        messages: {
            "price": {
            	required: "Please enter a valid price (30 or 30.00).",
            	floating_number: "Can only be a number with 0-2 decimal digits (30 or 30.00).",
            	min_digit: "The value cannot be all zeros."
            },
            "otherSize": {
            	required: "Please enter an ad size (.25 or 1.5).", 
            	floating_number: "Can only be a number with 0-2 decimal digits (.5 or .50).",
            	min_digit: "The value cannot be all zeros."
            },
            "user_action_time": "Please enter in the date and time when you did this."
        }
    });
    
    $('#page').change(function(){
      if ($("#page option:selected").text() == "Other") $('#otherSize').removeClass("hidden").show();      
      else $('#otherSize').addClass('hidden').hide();
    });
    
    $('#otherSize').keyup(function() {      
      var v = eval(this.value);      
      if (isFloat(v) || isInteger(v)) {
        $('#o').val(v.toFixed(2));      
        $('#page').val(v); // Moves dropdown to appropriate value if it is already provided
      }
      else $('#0').val(null);
    });
    
    // function isFloat and isInteger from http://stackoverflow.com/questions/3885817/how-to-check-if-a-number-is-float-or-integer
    function isFloat(n)   {return n === +n && n !== (n|0);}
    function isInteger(n) {return n === +n && n === (n|0);}
    
    onLoad(function() {
    var table =  $('.action_table').dataTable({
        "bPaginate" : false,
        "bFilter" : false,
        "bSort" : false,
        "iCookieDuration": 60,
        "bStateSave": false,
        "bAutoWidth": false,
        "bInfo" : false,
        "bProcessing": true,
        "bRetrieve": true,
        "bJQueryUI": true,
        "fnInitComplete": function() {
            this.css("visibility", "visible");
        },
        "fnPreDrawCallback": $(".autoHide").hide()
    }, $(".defaultTooltip").tooltip({
        'selector': '',
        'placement': 'left',
        'container': 'body'
    }));
  });
});
