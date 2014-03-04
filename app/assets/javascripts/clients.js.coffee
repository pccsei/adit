# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# This one is the default '.display' class options, add id to future tables to modify
$ ->
  load_datatable = ->
    $('.display').dataTable
      "sPaginationType" : "full_numbers"
      "sScrollX" : "100%"
      "bScrollCollapse" : true
      "iDisplayLength": 100
      "bJQueryUI": true
      "bDestroy": true
        
  $(document).ready(load_datatable)
  $(document).on('page:load', load_datatable)
  # Will add this function once it is ready 
  #$(document).on('page:change', load_datatable)

  #research the bDestroy feature
  
###
jQuery ->
  $('#ajaxTable').dataTable
    sPaginationType: "full_numbers"
    bJqueryUI: true
    bServerSide: true 
    sAjaxSource: $('#ajaxTable').data('source')
###
