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

setup_hover = function() {
	$('.user_image').hover(function(){$(this).toggleClass('user_image_hover');});

	$('.expo_logo_div').hover(
	function() {
	    $('.expo_return_text_div').animate({ "width": "186px" }, "slow" );
	}, function() {
	    $('.expo_return_text_div').animate({ "width": "0px" }, "slow" );
	});
}

$(window).load(function() {
	setup_hover();

});
$(document).on('page:load', setup_hover);

// Touch this code and die
window.onLoad = function(callback) {
    // binds ready event and turbolink page:load event
    $(document).ready(callback);
    $(document).on('page:load',   callback);
};

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

    $('table.default_table').each(function(i,table) {
        $('<div style="width: 100%; overflow: auto"></div>').append($(table)).insertAfter($('#' + $(table).attr('id') + '_wrapper div').first());
    });

    return table;
});




