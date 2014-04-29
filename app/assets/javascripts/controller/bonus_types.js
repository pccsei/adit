//*********************************************************************************************************************/
// User.js - everything needs to be wrapped in the onLoad function due to Turbolinks
//*********************************************************************************************************************/
onLoad(function() {

//*********************************************************************************************************************/
// Bonuses Front-Side Validation
//*********************************************************************************************************************/
	
	// Custom validation to make sure the bonus points number is in a valid format
	jQuery.validator.addMethod("valid_bonus", function(value, element) {
        return this.optional(element) || /^(\d{0,3})$/.test(value);
    });
	
	$("#student_options").validate({
		rules: {
			"bonus_points":  {required:  true, min: 1, max: 100, valid_bonus: true, leading_zero: true},
			"bonus_comment": {maxlength: 250}
		},
		messages: {
			"bonus_points": {
				required:     "Please enter the amount of bonus points.",
				min:          "Cannot be less than 1.",
				max:          "The maximum amount of bonus points is 100.",
				valid_bonus:  "Can only be a number from 1-100 (no decimal values).",
				leading_zero: "Cannot begin with zero."
			}
		}
	});
});