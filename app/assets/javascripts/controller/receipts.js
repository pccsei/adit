onLoad(function() {  
  $('.modal').modal({keyboard: true, show: false});
  $(".release_button").click(function(){
    $("#release_ticket_id").val(this.id);
  	$('.modal').modal('show');  	
  });
  
  $('.closeModal').click(function(){
  	$('.modal').modal('hide');
  });  
  
  $("#release_comment").keyup(function(){
    if ($('#release_comment').val().length > 0)
      $('#switchText').attr('value', "Comment and Release");
    else
      $('#switchText').attr('value', "Release");
  });
});
