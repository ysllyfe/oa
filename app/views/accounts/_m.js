<% if @searchbox_data %>
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
<% end %>
$('[data-rel=tooltip]').tooltip();


function change_user_roles(userid,roleid,method='add'){
    $.ajax({
        url:'/accounts/'+userid+'/role_ajax_change',
        data:'roleid='+roleid+'&m='+method,
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
          change_user_roles(dataid,id,'add');
            $(this).attr("checked","checked");
      } else {
          //选中，DELETEgroup
          change_user_roles(dataid,id,'del');
            $(this).attr("checked",false);
      }
  }
});
