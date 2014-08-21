jQuery(function($) {
	var $overflow = '';
	var colorbox_params = {
		rel: 'colorbox',
		reposition:true,
		scalePhotos:true,
		scrolling:false,
		previous:'<i class="ace-icon fa fa-arrow-left"></i>',
		next:'<i class="ace-icon fa fa-arrow-right"></i>',
		close:'&times;',
		current:'{current} of {total}',
		maxWidth:'100%',
		maxHeight:'100%',
		onOpen:function(){
			$overflow = document.body.style.overflow;
			document.body.style.overflow = 'hidden';
		},
		onClosed:function(){
			document.body.style.overflow = $overflow;
		},
		onComplete:function(){
			$.colorbox.resize();
		}
	};

	$('.ace-thumbnails [data-rel="colorbox"]').colorbox(colorbox_params);
	$("#cboxLoadingGraphic").append("<i class='ace-icon fa fa-spinner orange'></i>");//let's add a custom loading icon
});

ace.enable_searchbox_autocomplete = function (e) {
    ace.vars.US_STATES = [
<%=raw @searchbox_data.collect{|u| '"'+u.username+'"'}.join(',')%>
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
$('[data-rel=tooltip]').tooltip();
