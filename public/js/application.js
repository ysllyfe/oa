function ajax_frame_layout(obj){
	var w = $(window).width() > 800 ? '600px' : '400px';
	$.layer({
	    type: 2,
	    border: [0],
	    title: false,
	    fix : false,
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

});
function render_error(msg,title='页面出错了，提示信息如下！'){
	$.gritter.add({
			// (string | mandatory) the heading of the notification
			title: title,
			// (string | mandatory) the text inside the notification
			text: msg,
			class_name: 'gritter-error gritter-center'
		});
}
