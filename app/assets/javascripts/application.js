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
//= require turbolinks
//= require_self
//= require_tree .

// application.js

window.onLoad = function(callback) {
    // binds ready event and turbolink page:load event
    $(document).ready(callback);
    $(document).on('page:load',callback);
};