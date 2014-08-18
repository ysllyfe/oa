module ApplicationHelper
	def _user_space_url(user)
		'#'
	end

	def _true_or_false(t)
		if t
			raw '<span style="color: green">是</span>'
		else
			raw '<span style="color: red">否</span>'
		end
	end
	def _locked?(t,url="javascript:;",method='')
		if t
			raw '<a href="'+url+'" data-method="'+method+'" rel="nofollow"><i class="ace-icon fa fa-unlock green"></i></a>'
		else
			raw '<a href="'+url+'" data-method="'+method+'" rel="nofollow"><i class="ace-icon fa fa-lock orange"></i></a>'
		end
	end
	def _version(t)
		#bool t
		if t
			raw '<span style="color: green">正式版</span>'
		else
			raw '<span style="color: red">草稿</span>'
		end
	end
	def _round(f,num=4)
		return f.to_s.to_f.round(num)
	end
	def _sidebar_active(name,open=nil)
		if t("sidebar.#{name}") == @sidebar
			open ? 'active open' : 'active' 
		end
	end
	def _sidebar_menu(name,icon,url='')
		cls = arrow = ''
		html = []
		if url.blank?
			url = '#'
			cls = "dropdown-toggle"
			arrow = '<b class="arrow fa fa-angle-down"></b>'
		end
		html << "<a href='#{url}' class='#{cls}'>"
		html << "<i class='menu-icon fa #{icon}'></i>"
		html << '<span class="menu-text"> '
		html << t("sidebar.#{name}")
		html << "</span>#{arrow}</a><b class='arrow'></b>"
		return raw html.join('')
	end
	def _sidebar_submenu(name,url)
		active = t("sidebar.#{name}") == @submenu ? 'active' : ''
		html = []
		html << "<li class='#{active}'>"
		html << "<a href='#{url}'><i class='menu-icon fa fa-caret-right'></i>"
		html << t("sidebar.#{name}")
		html << "</a><b class='arrow'></b></li>"
		return raw html.join('')
	end
end
