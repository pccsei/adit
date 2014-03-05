# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


onLoad ->
    $(".hidden").hide()

    $("#presentation").click ->
      if $("#presentation").is(":checked")
         $("#checkers2").removeClass("hidden").show()
      else
         $("#checkers2").addClass("hidden").hide()
         $("#saleMade").hide()
         $("#sale").attr "checked", false
      return

    $("#sale").click ->
      if $("#sale").is(":checked")
         $("#saleMade").removeClass("hidden").show()
      else
         $("#saleMade").addClass("hidden").hide()
      return

    $("#comments").click ->
      if $("#comments").is(":checked")
         $("#justComment").removeClass("hidden").show()
      else
         $("#justComment").addClass("hidden").hide()
      return

    $("#foo_user_action_time").datetimepicker
      dateFormat: "yy/mm/dd"
      timeFormat: "hh:mm TT"
      maxDate: new Date

