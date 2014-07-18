$('.chosen-select').chosen({allow_single_deselect:true}); 
//resize the chosen on window resize
$(window).on('resize.chosen', function() {
	var w = $('.chosen-select').parent().width();
	$('.chosen-select').next().css({'width':w});
}).trigger('resize.chosen');
$('.date-picker').datepicker({
	autoclose: true,
	todayHighlight: true
})
.next().on(ace.click_event, function(){
	$(this).prev().focus();
});
