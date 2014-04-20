onLoad(function() {  
  // Grabs the server time to use as a timestamp. More comments on server-side.
  $.getJSON("tickets/get_sys_time", function(json) {
    window.sysTime = json.time; // Attach the timestamp to the window object to make it globally accessible
  });       
        
  // Allows the user to try to get the client.
  $(".addTicket").click(function(caller) {
    $.getJSON("tickets/getClient.json?clientID=" + caller.target.id, function(json) {
      if (json.Success != null) { // if successful
        $('#' + caller.target.id).addClass("autoHide").hide();
        selector =  $('#' + json.ticketPriority + "PriorityCount");        
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
    if ($(this).scrollTop() >= scroller_anchor - 50 && $(".scroller").css("position") !== "fixed") {
      $(".scroller").css({
        position: "fixed",
        top: "50px"
      });
      $(".scroller_anchor").css({
        height: $(".scroller").css("height")
      });
    } else if ($(this).scrollTop() < scroller_anchor - 50 && $(".scroller").css("position") !== "relative") {
      $(".scroller_anchor").css({
        height: 0
      });
      $(".scroller").css({  
        position: "relative",
        top: 0
      });
    }
  });
  
  function updateClients() {
    $.getJSON("tickets/updates?&timestamp=" + window.sysTime, function(json) {
      var i, len = json.length - 1; // compensating for system time appended to the end of JSON object
      for (i = 0; i < len; i++) {      	
        if (json[i].user_id == 0 || json[i].user_id == null)
             updateClient(json[i], "show");
        else updateClient(json[i], "hide");
      }
      window.sysTime = json[i]; // Update the timestamp to send to the server
      console.log("Updated at " + window.sysTime);
    });
    setTimeout(updateClients, 2000);
  }  
  
  function updateClient(c, action) {
  	if (action == 'show') {
  	  $('#' + c.id).show();
      $('#' + c.id).removeClass("autoHide");
      $('#' + c.id + '_span').html("");
     }
  	else {
      $('#' + c.id).hide();
      $('#' + c.id).addClass("autoHide");
      $('#' + c.id + '_span').html(c.first_name + " " + c.last_name+ "<br />(" + c.school_id + ")");
  	}  	
  }
  
  
  function updateCounters(selector) {
    highSelector   = $('#highPriorityCount');
    mediumSelector = $('#mediumPriorityCount');
    lowSelector    = $('#lowPriorityCount');
    
    if (selector.html() > 0)
      mm(selector);      
      
    // Check for the existence of totalLeft  
    if (typeof $('#clientsRemaining') !== 'undefined') { 
      var totalLeft  = parseInt($('#clientsRemaining').html());
      
      // Update the total counter 
      if (totalLeft > 0) {
        $('#clientsRemaining').html(totalLeft - 1);
        totalLeft--;        
      }
      
      // Check all the counters to make sure they are not greater than the total
      if (parseInt(highSelector.html()) > totalLeft){
        highSelector.html(totalLeft);
      }
      if (mediumSelector.html() > totalLeft)
        mediumSelector.html(totalLeft);
      if (lowSelector.html() > totalLeft)
        lowSelector.html(totalLeft);
    }        
  }
    
  // This function is similar to a -- on a variable except it accepts the element that has a number in it
  function mm(selector) {selector.html(selector.html() - 1);}

  // Recursive function that pings the server to check for updates
  setTimeout(updateClients, 1000);  
  
 overridePrioritySort();
  
  // Initialized the datatable with the bootstrap tooltip feature added
  var table =  $('.ticket_table').dataTable({
        "aoColumns" : [{"sWidth": "12%"}, {"sType": "priority", "sWidth": "8%" }, { "bSortable": true, "sWidth": "26%" }, {"sWidth": "26%"}, {"sWidth": "18%"}, {"sWidth": "10%"}],
        "bPaginate" : false,
        "iCookieDuration": 60,
        "bStateSave": false,
        "bAutoWidth": false,
        "bProcessing": true,
        "bRetrieve": true,
        "bJQueryUI": true,
        "fnPreDrawCallback": $(".autoHide").hide()
         }, 
         $(".defaultTooltip").tooltip({
        'selector': '',
        'placement': 'left',
        'container': 'body'
    }));

  return table;
});