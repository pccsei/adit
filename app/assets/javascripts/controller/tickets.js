onLoad(function() {  
  // Grabs the server time to use as a timestamp
  $.getJSON("tickets/get_sys_time", function(json) {
    window.sysTime = json.time;
  });       
        
  $(".addTicket").click(function(caller) {
  //console.log(caller.target.id);
    $.getJSON("tickets.json?ajax=getClient&clientID=" + caller.target.id, function(json) {
      // TODO: Change URL above ^^^ to use Rails helper
      if (json.Success != null) {
        $('#' + caller.target.id).addClass("autoHide").hide();
        console.log("You got the client!");
        selector =  $('#' + json.ticketPriority + "PriorityCount");        
        //selector.html(selector.html() - 1);
        //$('#clientsRemaining').html($('#clientsRemaining').html() - 1);
        updateCounters(selector);
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
    $.getJSON("tickets.json?ajax=update&timestamp=" + window.sysTime, function(json) {
      //TODO: Change URL above ^^^ to use Rails helper
      var i, len = json.length - 1; // compensating for system time appended to the end of JSON object
      for (i = 0; i < len; i++) { 
      //console.log(json[i]);
      //console.log($('#' + json[i]));
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
    });
    //setTimeout(updateClients, 2000);
  }
  
  function updateCounters(selector) {    
    console.log("updating counters");
    highSelector   = $('#highPriorityCount');
    mediumSelector = $('#mediumPriorityCount');
    lowSelector    = $('#lowPriorityCount');
    
    if (selector.html() > 0)
      mm(selector);      
      
    // Check for the existence of totalLeft  
    if (typeof $('#clientsRemaining') !== 'undefined') {  
      console.log("#clientsRemainins was found. Proceeding to update counters");
      var totalLeft  = parseInt($('#clientsRemaining').html());
      
      // Update the total counter 
      if (totalLeft > 0) {
        $('#clientsRemaining').html(totalLeft - 1);
        totalLeft--;        
      }
      
      console.log("highSelector .html() value -----> " + highSelector.html());
      console.log(totalLeft);
      // Check all the counters to make sure they are not greater than the total
      if (parseInt(highSelector.html()) > totalLeft){
        console.log("exceeded high count limit. Diminishing highCount");
        highSelector.html(totalLeft);
      }
      if (mediumSelector.html() > totalLeft)
        mediumSelector.html(totalLeft);
      if (lowSelector.html() > totalLeft)
        lowSelector.html(totalLeft);
    }        
  }
    
  function mm(selector) {selector.html(selector.html() - 1);}

  setTimeout(updateClients, 1000);
});


