onLoad(function() {  
  // Grabs the server time to use as a timestamp
  $.getJSON("/tickets/get_sys_time", function(json) {
    window.sysTime = json.time;
  });       
        
  $(".addTicket").click(function(caller) {
  //console.log(caller.target.id);
    $.getJSON("/tickets.json?ajax=getClient&clientID=" + caller.target.id, function(json) {
      // TODO: Change URL above ^^^ to use Rails helper
      if (json.Success != null) {
        $('#' + caller.target.id).addClass("autoHide").hide();
        console.log("You got the client!");
        selector =  $('#' + json.ticketPriority + "PriorityCount");        
        selector.html(selector.html() - 1);
        $("#userMessage").hide().html(json.Success).fadeIn(1000);
      }
      else
        $("#userMessage").hide().html(json.userMessage).fadeIn(1000);
    });
  });

  $(window).scroll(function(e) {
    var scroller_anchor;
    scroller_anchor = $(".scroller_anchor").offset().top;
    if ($(this).scrollTop() >= scroller_anchor && $(".scroller").css("position") !== "fixed") {
      $(".scroller").css({
        position: "fixed",
        top: "0px"
      });
      $(".scroller_anchor").css("height", "50px");
    } else if ($(this).scrollTop() < scroller_anchor && $(".scroller").css("position") !== "relative") {
      $(".scroller_anchor").css("height", "0px");
      $(".scroller").css({
        position: "relative"
      });
    }
  });
  
  function updateClients() {
    $.getJSON("/tickets.json?ajax=update&timestamp=" + window.sysTime, function(json) {
      //TODO: Change URL above ^^^ to use Rails helper
      var i, len = json.length - 1; // compensating for system time appended to the end of JSON object
      for (i = 0; i < len; i++) { 
      console.log(json[i]);
        if (json[i].user_id == 0 || json[i].user_id == null) {
          $('#' + json[i].id).show();
          $('#' + json[i].id).removeClass("autoHide");
          console.log('#' + json[i].client_id);
        }
        else {
          $('#' + json[i].id).hide();
          $('#' + json[i].id).addClass("autoHide");
          console.log('#' + json[i].id);
        }
      }
      window.sysTime = json[i];
      console.log("Updated at " + window.sysTime);
      setTimeout(updateClients, 2000);
    });
  }
  setTimeout(updateClients, 1000);
});


