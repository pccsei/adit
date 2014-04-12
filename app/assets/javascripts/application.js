// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery
//= require bootstrap
//= require dataTables/jquery.dataTables
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require jquery.ui.slider
//= require jquery-ui-sliderAccess
//= require jquery-ui-timepicker-addon
//= require jquery-ui-timepicker-addon.min
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.ui.effect
//= require jquery.ui.selectable
//= require jquery.ui.accordion
//= require turbolinks
//= require_self
//= require_directory .

// Touch this code and die. This makes all the Javascript work with Turbolinks.
window.onLoad = function(callback) {
    // binds ready event and turbolink page:load event
    $(document).ready(callback);
    $(document).on('page:load',   callback);
};

// This initializes all the default dataTables in the application
onLoad(function() {
 
    var table =  $('.default_table').dataTable({
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

    // Enables scrolling - very nice feature. Without it, the columns do not align.
    $('table.default_table').each(function(i,table) {
        $('<div style="width: 100%; overflow: auto"></div>').append($(table)).insertAfter($('#' + $(table).attr('id') + '_wrapper div').first());
    });

    return table;
});


    function overridePrioritySort(){
      
      // The following is a custom override of the column sorting so that the tickets will push high, medium, and low to the top of the column
      var priorities = ['high', 'medium', 'low'];
      var index      = 0; 
      var ascFlag    = true;
      var descFlag   = true;  
      
      var priorityArray = {};
      priorityArray['High']   = 0;
      priorityArray['Medium'] =-1;
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
    }
