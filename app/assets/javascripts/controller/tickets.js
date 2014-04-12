onLoad(function() {  
  // Grabs the server time to use as a timestamp. More comments on server-side.
  $.getJSON("tickets/get_sys_time", function(json) {
    window.sysTime = json.time; // Attach the timestamp to the window object to make it globally accessible
  });       
        
  // Allows the user to try to get the client.
  $(".addTicket").click(function(caller) {
    $.getJSON("tickets.json?ajax=getClient&clientID=" + caller.target.id, function(json) {
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
    $.getJSON("tickets/updates.json?ajax=update&timestamp=" + window.sysTime, function(json) {
      //TODO: Change URL above ^^^ to use Rails helper
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
  
  // The following is a custome override of the column sorting so that the tickets will push high, medium, and low to the top of the column
  var priorities = ['high', 'medium', 'low'];
  var index      = 0; 
  var ascFlag    = true;
  var descFlag   = true;  
  
  var priorityArray = {};
  priorityArray['High']   =-1;
  priorityArray['Medium'] = 0;
  priorityArray['Low']    = 1;
  
  function updatePriorityArray(){
    priorityArray['High']   = ((priorityArray['High']   + 2) % 3) - 1;
    priorityArray['Medium'] = ((priorityArray['Medium'] + 2) % 3) - 1;
    priorityArray['Low']    = ((priorityArray['Low']    + 2) % 3) - 1;
  }
  
  // Both the ascending function and descending function have to be overridden since they are called in alternate.
  jQuery.fn.dataTableExt.oSort['priority-asc'] = function(x,y) {
  
    if (descFlag) { // This prevents the the priority array from going moving more than once per cycle since this function gets called multiple times during the sort. 
      index++;
      index   %= priorities.length;
      ascFlag  = true;
      descFlag = false;   
      updatePriorityArray();
    }
    var currentPriority = priorities[index];
    
    // This strips out the span tags I added to the td. - Rob
    x = $(x).text();
    y = $(y).text();

    if (x == (currentPriority) && y == (currentPriority)) 
      return 0;
    else if (x == (currentPriority))
      return -1;
    else if (y == (currentPriority)) 
      return 1;
    else 
      return ((priorityArray[x] < priorityArray[y]) ?  1 : ((priorityArray[x] > priorityArray[y]) ? -1: 0 ) );
  };
  
  // This one too
  jQuery.fn.dataTableExt.oSort['priority-desc'] = function(x,y) {
  
    if (ascFlag) {
      index++;
      index   %= priorities.length;
      ascFlag  = false;
      descFlag = true;   
      updatePriorityArray();
    }   
    var currentPriority = priorities[index];
        
    // This strips out the span tags I added to the td. - Rob
    x = $(x).text();
    y = $(y).text();

    if (x == (currentPriority) && y == (currentPriority))
      return 0;
    else if (x == (currentPriority))
      return -1;
    else if (y == (currentPriority)) 
      return 1;
    else
      return ((priorityArray[x] < priorityArray[y]) ?  1 : ((priorityArray[x] > priorityArray[y]) ? -1: 0 ) );
  };
  
  // Initialized the datatable with the bootstrap tooltip feature added
  var table =  $('.ticket_table').dataTable({
        "aoColumns" : [{ "bSortable": true }, {"sType": "priority" }, null, null, null, null, null],
        "bPaginate" : false,
        "iCookieDuration": 60,
        "bStateSave": false,
        "bAutoWidth": false,
        "bScrollAutoCss": true,
        "bProcessing": true,
        "bRetrieve": true,
        "bJQueryUI": true,
        "sDom": '<"H"CTrf>t<"F"lip>',
        "sScrollXInner": "110%",
        "fnInitComplete": function() {
            this.css("visibility", "visible");
        },
        "fnPreDrawCallback": $(".autoHide").hide()
    }, $(".defaultTooltip").tooltip({
        'selector': '',
        'placement': 'left',
        'container': 'body'
    }));

    $('table.ticket_table').each(function(i,table) {
        $('<div style="width: 100%; overflow: auto"></div>').append($(table)).insertAfter($('#' + $(table).attr('id') + '_wrapper div').first());
    });

  return table;
});