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
            "client[telephone]": {required: true, valid_telephone: true}
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

} );