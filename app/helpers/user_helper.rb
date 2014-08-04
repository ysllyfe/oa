module UserHelper
	def _birth(user)
		return user.info.lunar if !user.info.lunar.blank?
		return user.staff.birth
	end
	def _depart_operate(ischecked,options={})
		html = []
		if ischecked
			if options['delete']
				html << '<a href='+options['delete']+' class="btn btn-xs btn-danger" data-method="delete" data-confirm="确认删除？" rel="nofollow">'
				html << '<i class="ace-icon fa fa-trash-o bigger-120"></i>'
				html << '</a>'
			end
		else
			#edit destroy
			if options['edit']
				html << '<a class="btn btn-xs btn-info">'
				html << '<i class="ace-icon fa fa-pencil bigger-120"></i>'
				html << '</a>'
			end
			if options['delete']
				html << '<a class="btn btn-xs btn-danger">'
				html << '<i class="ace-icon fa fa-trash-o bigger-120"></i>'
				html << '</a>'
			end
		end
		raw html.join
	end
end