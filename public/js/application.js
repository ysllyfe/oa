function ajax_frame_layout(obj){
	var w = $(window).width() > 800 ? '600px' : '400px';
	$.layer({
	    type: 2,
	    border: [0],
	    title: false,
	    shadeClose: true,
	    offset: ['50px', ''],
	    iframe: {src : $(obj).attr('href')},
	    area: [ w , '30px']
	});
}
$(document).ready(function(){
	$('.ajax_iframe').bind('click',function(event){
		ajax_frame_layout(this);
		event.preventDefault();
	});

})