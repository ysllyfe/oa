$('.chosen-select').chosen({allow_single_deselect:true}); 
$('.date-picker').datepicker({
	autoclose: true,
	todayHighlight: true
})
.next().on(ace.click_event, function(){
	$(this).prev().focus();
});


ace.enable_searchbox_autocomplete = function (e) {
    ace.vars.US_STATES = [
<%=raw @searchbox_data.collect{|u| '"'+u.title+'"'}.join(',')%>
    ];
    try {
        e('#nav-search-input') .typeahead({
            source: ace.vars.US_STATES,
            updater: function (a) {
                return e('#nav-search-input') .focus(),
                a
            }
        })
    } catch (a) {
    }
};