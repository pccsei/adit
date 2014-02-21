$ ->
  load_datatable = ->
    $('.dataTable').dataTable( {
       "iDisplayLength": 50
     })
 
  $(document).ready(load_datatable)
  $(document).on('page:load', load_datatable)
  # Will add this function once it is ready 
  #$(document).on('page:change', load_datatable)