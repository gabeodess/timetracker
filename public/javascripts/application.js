function zebra(item){
  var toggle = 'even';
  item.children().each(function(){
    $(this).removeClass('even');
    $(this).removeClass('odd');
    if(toggle == 'even'){toggle = 'odd'}else{toggle = 'even'}
    $(this).addClass(toggle);
  })
}

$(document).ready(function(){
	
	// ================
	// = Flash Notice =
	// ================
	var flash = $('#content_for_flash');
	var height = flash.height();
	flash.height(0);
  $('#content_for_flash').animate({height:20}, 500);
  // $('#content_for_flash').fadeOut(10000);
	
	
	// $(".gallery").gallery();
  $('form:first input[type=text]:first').focus();
	
	// $(".draggable").draggable({
	// 	containment: 'parent'
	// });
	
	// $('.dataTable').dataTable({
	// 	"bFilter": false,
	// 	"bLengthChange": false
	// });
	// $('.dataTableDesc').dataTable({
	// 	"bFilter": false,
	// 	"bLengthChange": false,
	// 	"aaSorting": [[0,'desc']]
	// });
	// 
  // $('.overlay[rel]').overlay({});  
	
	$($('.blind[rel]').attr('rel')).hide();
	$('.blind').click(function(){
		if($($(this).attr('rel')).css('display') == 'none'){
			$($(this).attr('rel')).show('blind', {direction: 'vertical'}, 100);
			window.location.hash = $(this).attr('rel') + '=' + 'visible';
		}else{
			$($(this).attr('rel')).hide('blind', {direction: 'vertical'}, 100);
			window.location.hash = $(this).attr('rel') + '=' + 'hidden';
		}
	});
})