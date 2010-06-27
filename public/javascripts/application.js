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
	$('#content_for_flash').show('blind', {direction:'vertical'}, 500);
	$('#content_for_flash').fadeOut(10000);
	
	
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

	// $('.blind').click(function(){
	// 	if($($(this).attr('rel')).css('display') == 'none'){
	// 		$($(this).attr('rel')).show('blind', {direction: 'vertical'}, 1000);
	// 		window.location.hash = $(this).attr('rel') + '=' + 'visible';
	// 	}else{
	// 		$($(this).attr('rel')).hide('blind', {direction: 'vertical'}, 1000);
	// 		window.location.hash = $(this).attr('rel') + '=' + 'hidden';
	// 	}
	// });
})