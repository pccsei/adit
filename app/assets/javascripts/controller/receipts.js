onLoad(function() {  
  $('.modal').modal({keyboard: true, show: true});
  $(".release_button").click(function(){
    $("#release_ticket_id").val(this.id);
  	$('.modal').modal('show');  	
  });
  
  $('.closeModal').click(function(){
  	$('.modal').modal('hide');
  });  
});
