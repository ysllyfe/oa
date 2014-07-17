module TableHelper
	def _simple_thead(i18n_setting)
		html = []
		html << "<thead><tr>"
		i18n_setting.each do |f,val|
			if val.class == Hash
				html << "<th class='#{val[:class]}'>#{val[:tname]}</th>"
			else
				html << "<th>#{val}</th>"
			end
		end
		html << "</tr></thead>"
		return raw html.join('')
	end
end