



$(window).scroll(function(e) {
  var scroller_anchor;
  scroller_anchor = $(".scroller_anchor").offset().top;
  if ($(this).scrollTop() >= scroller_anchor && $(".scroller").css("position") !== "fixed") {
    $(".scroller").css({
      position: "fixed",
      top: "0px"
    });
    $(".scroller_anchor").css("height", "50px");
  } else if ($(this).scrollTop() < scroller_anchor && $(".scroller").css("position") !== "relative") {
    $(".scroller_anchor").css("height", "0px");
    $(".scroller").css({
      position: "relative"
    });
  }
});



