onLoad(function() {  
  $(".release_button").click(function() {
    console.log("release button clicked");
  
    if (confirm("Are you sure you want to release this client?")) {
      $.get('/tickets/release.js?id=' + this.id, function(){ 
        location.reload(true);
      });
    }
  });
});
