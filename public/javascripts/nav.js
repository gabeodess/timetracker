// =========
// = Usage =
// =========
// <script type='text/javascript' src='/javascripts/jquery.js'></script>
// <script type='text/javascript' src='/javascripts/bbq.js'></script>
// <script type='text/javascript' src='/javascripts/nav.js'></script>
// 
// <ul id='content_nav'>
// 	<li><a rel='#rel1'>Rel 2</a></li>
// 	<li><a rel='#rel2'>Rel 1</a></li>
// </ul>
// 
// <div>
// 	<div id='rel1'>...</div>
// 	<div id='rel2'>...</div>
// </div>

$(function(){
	var myObj = $.deparam.fragment();
	if(myObj['current_nav'] == null){
		var a_nav = $('#content_nav li a:first');
	}else{
		var a_nav = $('a[rel|=#' + myObj['current_nav'] +']');
	};
	select_nav(a_nav);
	$('#content_nav li a').click(function(){
		select_nav($(this));
	});
})
function select_nav(item){
	$('#content_nav li a').removeClass('active');
	item.addClass('active');
	var rel = $(item.attr('rel'));
	rel.siblings().hide();
	rel.show();
	
	window.location.hash = "current_nav=" + rel.attr('id');
}
