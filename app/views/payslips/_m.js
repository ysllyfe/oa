$('.date-picker').datepicker({
		autoclose: true,
		todayHighlight: true
	})
	//show datepicker when clicking on the icon
	.next().on(ace.click_event, function(){
		$(this).prev().focus();
	});

function c(id){
	$.ajax({
		type: "GET",
		url: "<%=my_payslips_url%>",
		data: { id:id }
	}).done(function( msg ) {
		$('#'+id).find('.panel-body').html(msg);
	});
}