onLoad(function() {  
  $('.modal').modal({keyboard: true, show: false});
  $(".release_button").click(function(){
    $("#ticket_id").val(this.id);
  	$('.modal').modal('show');  	
  });
  
  $('.closeModal').click(function(){
  	$('.modal').modal('hide');
  });  
  
  $("#body").keyup(function(){
    if ($('#body').val().length > 0)
      $('#switchText').attr('value', "Comment and Release");
    else
      $('#switchText').attr('value', "Release");
  });
});
