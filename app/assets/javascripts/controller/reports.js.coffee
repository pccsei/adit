$ ->
  load_datatable = ->
    $('.display').dataTable
      "sPaginationType" : "full_numbers"
      "sScrollX" : "100%"
      "bScrollCollapse" : true
      "iDisplayLength": 50
      "bJQueryUI": true
      "bDestroy": true
  
  $(document).ready(load_datatable)
  $(document).on('page:load', load_datatable)
  # Will add this function once it is ready 
  #$(document).on('page:change', load_datatable)

  #research the bDestroy feature