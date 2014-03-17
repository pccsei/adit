onLoad(function() {


    // Users index page
    $( "#show_managers" ).hide();
    $("#parse_box").hide();
    $( "#option" ).click(
        function( event) {
            event.preventDefault();
            var e = document.getElementById("selected_option");
            var strUser = e.options[e.selectedIndex].text;
            if(strUser=="Assign Team")
            {
                $( "#show_managers" ).show();
            }
            else
            {
                $( "#show_managers" ).hide();
            }
        }
    );
    $(function() {
        $("#paste").click(
            function() {


                $("#parse_box").toggle();
            });
    });


    // Teachers.html.erb
    $("#Change_Teacher").hide();
    $("#New_Teacher").hide();

    $(".Change_Teacher_Link").click(
        function(caller) {

            if ($("#Change_Teacher").is(":hidden") ){
                $("#New_Teacher").hide();
                $("#Change_Teacher").show();
            }

            console.log(
                $("#" + caller.target.id).attr("name")
            );

            $("#oldTeacher").html( $("#" + caller.target.id).attr("name") );
            $("#memberId").val( $("#" + caller.target.id).attr("value") );
        });


    $(".New_Teacher_Link").click(
        function(caller) {

            if ($("#New_Teacher").is(":hidden") ){
                $("#Change_Teacher").hide();
                $("#New_Teacher").show();
            }

            console.log(
                $("#" + caller.target.id).attr("name")
            );

            $("#sectionNumber").html( $("#" + caller.target.id).attr("name") );
            $("#section").val( $("#" + caller.target.id).attr("name") );
        });


    // Custom method to make sure only letters are entered
    jQuery.validator.addMethod("letters_only", function(value, element) {
        return this.optional(element) || /^[-a-zA-Z\s ?()'\/&-\.]+$/i.test(value);
    });

    // Custom method to make sure only letters and numbers are entered (no symbols or punctuation)
    jQuery.validator.addMethod("id_valid", function(value, element) {
        return this.optional(element) || /^([-a-zA-Z]|[0-9])+$/i.test(value);
    });

	// Custom method to make sure the email is a valid PCC email address
    jQuery.validator.addMethod("email_valid", function(value, element) {
        return this.optional(element) || /^([^@\s]+)@(students.pcci.edu|faculty.pcci.edu)$/i.test(value);
    });

    // Custom method to make sure the telephone is valid
    jQuery.validator.addMethod("valid_telephone", function(value, element) {
        return this.optional(element) || /^(([tT][oO][wW][nN])|(((17)\s*[-]\s*)?(\d{4})\s*[-]\s*([1-4]{1}))*|((([1-9][0-9][0-9])?\s*[-]\s*)*([1-9][0-9][0-9])\s*[-]\s*(\d{4})\s*(([eE][xX][tT])\.?\s*(\d{1,4}))*))$/.test(value);
    });

    $("#new_user").validate({
        rules: {
            "user[first_name]": {required: true, letters_only: true},
            "user[last_name]": {required: true, letters_only: true},
            "user[school_id]": {required: true, id_valid: true},
            "user[email]": {required: true, email: true, email_valid: true},
            "user[phone]": {valid_telephone: true}
        },
        messages: {
            "user[first_name]": "Please enter the user's first name.",
            "user[last_name]": "Please enter the user's last name.",
            "user[school_id]": "Please enter the user's school id.",
            "user[email]": "Please enter the user's PCC email address.",
            "user[phone]": "Please enter the user's phone number."
        }
    });
});
