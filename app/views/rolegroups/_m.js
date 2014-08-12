function change_group_roles(groupid,roleid,method='add'){
	$.ajax({
		url:'/rolegroups/'+groupid+'/role_ajax_change',
		data:'roleid='+roleid+'&m='+method,
		type: 'get',
		success:function(msg){
			console.log(msg);
		}
	})
}
function change_group_users(groupid,userid,method='add'){
	$.ajax({
		url:'/rolegroups/'+groupid+'/user_ajax_change',
		data:'userid='+userid+'&m='+method,
		type: 'get',
		success:function(msg){
			console.log(msg);
		}
	})
}
$('.ace-switch-5').on('click', function(obj) {
	var id = $(this).val();
	var dataid = $(this).attr('data-id');
	if(dataid){
	  if ($(this).attr("checked")==undefined) {
	      //未选中，则ADDgroup
	      change_group_roles(dataid,id,'add');
	    	$(this).attr("checked","checked");
	  } else {
	      //选中，DELETEgroup
	      change_group_roles(dataid,id,'del');
	    	$(this).attr("checked",false);
	  }
  }
});

$('.ace-switch-4').on('click', function(obj) {
	var id = $(this).val();
	var dataid = $(this).attr('data-id');
	if(dataid){
	  if ($(this).attr("checked")==undefined) {
	      //未选中，则ADDgroup
	      change_group_users(dataid,id,'add');
	    	$(this).attr("checked","checked");
	  } else {
	      //选中，DELETEgroup
	      change_group_users(dataid,id,'del');
	    	$(this).attr("checked",false);
	  }
  }
});