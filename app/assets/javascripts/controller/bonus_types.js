
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
	
	// Custom method to make sure a number does not start with a zero
    jQuery.validator.addMethod("leading_zero", function(value, element) {
        return this.optional(element) || /^([1-9]+(\d)*|[-a-zA-Z1-9]+)$/.test(value);
    });
    
	$("#bonus_types").validate({
		rules: {
			"bonus_type[name]":        {required: true, maxlength:   250},
			"bonus_type[point_value]": {required: true, valid_bonus: true, min: 1, max: 100, leading_zero: true}
		},
		messages: {
			"bonus_type[name]": {
				required:     "Please enter the Bonus Name.",
				maxlength:    "The maximum length for a name is 250 characters."
			},	
			"bonus_type[point_value]": {
				required:     "Please enter the amount of bonus points.",
				valid_bonus:  "Can only be a number from 1-100 (no decimal values).",
				min:          "Cannot be less than 1.",
				max:          "The maximum amount of bonus points is 100.",
				leading_zero: "Cannot begin with zero."
			}
		}
	});
});
