


onLoad ->
  
    $('.display').dataTable
      "sPaginationType" : "full_numbers"
      "sScrollX" : "100%"
      "bScrollCollapse" : true
      "iDisplayLength": 50
      "bJQueryUI": true
      "bDestroy": true
      "fnPreDrawCallback": $(".autoHide").hide();$(".defaultTooltip").tooltip({'selector': '','placement': 'left','container':'body'});

# Will add this function once it is ready
#$(document).on('page:change', load_datatable)

#research the bDestroy feature