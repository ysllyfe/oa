module RoleHelper
	def _check_view(id,checked,url,role,method="put")
		html = []
		#check-square-o
		#times-circle
		icon = checked ? 'fa-check-square-o' : 'fa-times-circle'
		text = checked ? '取消审核' : '通过审核'
		cls = checked ? 'btn  btn-xs btn-danger' : 'btn  btn-xs btn-success'
		html << "<a href='#{url}' class='#{cls}' data-remote='true' data-method='#{method}' data-confirm='' rel='nofollow'>"
		html << "#{text}"
		html << '</a> | '
		if @logged_in_user.has_role?(role)
			raw html.join("")
		else
			''
		end
	end
	def _user_role(roles,role,user_id=0)
		check = ''
		if roles.include?(role)
			check = 'checked="checked"'
		end
		html = []
		html << '<label class="pull-right inline">'
		html << '<input type="checkbox" value="'+role.to_s+'" data-id="'+user_id.to_s+'" class="ace ace-switch ace-switch-5" '+check+' id="id-button-borders">'
		html << '<span class="lbl middle"></span></label>'
		raw html.join("")
	end
	def _group_role(roles,role,rolegroup_id=0)
		check = ''
		if roles.include?(role)
			check = 'checked="checked"'
		end
		html = []
		html << '<label class="pull-right inline">'
		html << '<input type="checkbox" value="'+role.to_s+'" data-id="'+rolegroup_id.to_s+'" class="ace ace-switch ace-switch-5" '+check+' id="id-button-borders">'
		html << '<span class="lbl middle"></span></label>'
		raw html.join("")
	end
	def _group_user(users,userid,rolegroup_id=0)
		check = ''
		if users.include?(userid)
			check = 'checked="checked"'
		end
		html = []
		html << '<label class="pull-right inline">'
		html << '<input type="checkbox" value="'+userid.to_s+'" data-id="'+rolegroup_id.to_s+'" class="ace ace-switch ace-switch-4" '+check+' id="id-button-borders">'
		html << '<span class="lbl middle"></span></label>'
		raw html.join("")
	end
end