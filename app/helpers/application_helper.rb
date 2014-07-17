module ApplicationHelper
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
		html = []
		html << "<li class=''>"
		html << "<a href=''><i class='menu-icon fa fa-caret-right'></i>"
		html << t("sidebar.#{name}")
		html << "</a><b class='arrow'></b></li>"
		return raw html.join('')
	end
end
