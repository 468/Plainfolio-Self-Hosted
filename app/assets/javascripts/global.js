$(document).on('page:change', function (){

  $('.best_in_place').best_in_place();

  $('#flash_notice, #flash_error, #flash_alert').delay(2000).fadeOut(500);

  $('#flash-close').click(function(){
  	$(this).parent().hide();
  })

  $('#pdf-button').click(function(){
  	$(".loader").show();
  })

  $('#create-portfolio').click(function(){
  	$(".loader").show();
  })

});