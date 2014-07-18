var steeltype_index = factory_index = 0;
$(document).delegate('.steeltype_choose','click',function(event){
	$(this).powerFloat({ eventType: "click"});
	steeltype_index = $(".steeltype_choose").index($(this));
	//console.log("steeltype_index:" + steeltype_index);
});
$(document).delegate('.factory_choose','click',function(){
	$(this).powerFloat({ eventType: "click"});
	factory_index = $(".factory_choose").index($(this));
	//console.log("factory_index:" + factory_index);
});

$('#steeltypeBox a').bind('click',function(){
	var text = $(this).text();
	var id = $(this).attr('data-id');
	$('.steeltype_choose:eq('+steeltype_index+')').parent().find('span').text(text);
	$('.steeltype_choose:eq('+steeltype_index+')').parent().find('input').val(id);
});
$('#factoryBox a').bind('click',function(){
	var text = $(this).text();
	var id = $(this).attr('data-id');
	$('.factory_choose:eq('+factory_index+')').parent().find('span').text(text);
	$('.factory_choose:eq('+factory_index+')').parent().find('input').val(id);
})
$("._addtypes").bind('click',function(){
	$.ajax({
		url:'<%=new_project_truck_url%>',
		type: 'get',
		success: function(msg){
			$(msg).appendTo($('#type_box'));
		}
	})
});