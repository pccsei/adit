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
    setTimeout(updateClients, 2000);
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

  // Recursive function that pings the server to check for updates
  setTimeout(updateClients, 1000);
  
  
  // Begin the 
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
  
  // This function enable the datatable on the tickets page to cycle through priorities.
  jQuery.fn.dataTableExt.oSort['priority-asc'] = function(x,y) {
  
    if (descFlag) {
      index++;
      index   %= priorities.length;
      ascFlag  = true;
      descFlag = false;   
      updatePriorityArray();
      console.log("asc called");
      console.log("pushing " + priorities[index] + " to the top");
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
      console.log("desc called");
      console.log("pushing " + priorities[index] + " to the top");
      var nextIndex = index;
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
  
  // Initialized the datatable
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


