//*********************************************************************************************************************/
// Bonus Summary Page
//*********************************************************************************************************************/
onLoad(function () {
    $("#bonus_edit").hide();
    
    $(function() {
      $(".edit_link").click(
        function(caller) {
          $("#bonus_edit").show();

          $("#bonus_edit").show();
          $("#bonus_points").val( $("#" + caller.target.id).attr("name") );
          $("#bonus_comment").val( $("#" + caller.target.id).attr("value") );
          $("#bonus_id").val( $("#" + caller.target.id).attr("title") );
        }
      );
    });


    $( "div.bonus_accordion" ).accordion({
      header: "> h3:not(.item)",
      collapsible: true,
      autoHeight: false,
      heightStyle: "content",
      active: false
    });
    $( "div.bonus_accordion" ).accordion({
      header: "> h3:not(.item)",
      collapsible: true,
      autoHeight: false,
    heightStyle: "content",
    active: false
    });
    
//*********************************************************************************************************************/
// Bonuses Front-Side Validation
//*********************************************************************************************************************/
	
	// Custom validation to make sure the bonus points number is in a valid format
	jQuery.validator.addMethod("valid_bonus", function(value, element) {
        return this.optional(element) || /^(\d{0,3})$/.test(value);
    });
	
	$("#edit_bonus_points").validate({
		rules: {
			"bonus_points":  {required:  true, min: 0, max: 100, valid_bonus: true},
			"bonus_comment": {maxlength: 250}
		},
		messages: {
			"bonus_points": {
				required:     "Please enter the amount of bonus points.",
				min:          "Cannot be less than 0.",
				max:          "The maximum amount of bonus points is 100.",
				valid_bonus:  "Can only be a number from 0-100 (no decimal values)."
			}
		}
	});
});
