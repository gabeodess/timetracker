$(function(){
  $('#flash_wrapper').click(function(){
    $(this).animate({height:0}, 250, function(){$(this).hide()});
  });
});