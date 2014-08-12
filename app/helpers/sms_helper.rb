module SmsHelper
	def _sms_obj(sms)
		html = []
		tg = false
		if !sms.departments.blank?
			g = Group.where(system:true).order('id asc')
			deps = GroupDepartment.where("id in (?)",sms.departments.split(',')).order('id asc')
			g.each do |t|
				if tg == false
					tg = true
				else
					html << '<br />'
				end
				html << '<b>'+t.name+':</b>'
				deps.each do |f|
					if f.group_id==t.id
						html << ' ' + f.name
					end
				end
			end
		end
		if !sms.smsgroups.blank?
			smsgroups = Smsgroup.where("id in (?)",sms.smsgroups.split(',')).order('id asc')
			if tg == false
				tg = true
			else
				html << '<br />'
			end
			html << "<b>其它:</b>"
			smsgroups.each do |f|
				html << ' ' + f.name
			end
		end
		raw html.join('')
	end
	def _sms_status(statusinfo)
		case statusinfo 
		when 'Command complateted successfully'
			'发送成功'
		when 'notsend'
			'未发送'
		else
			statusinfo
		end
	end
	def _smsgroup_checkbox(groups,alreadexist=[])
		html = []
		alread_group = alreadexist ? alreadexist.split(',') : Array.new
		groups.each do |f|
			checked = ''
			if alread_group.include?(f.id.to_s)
				checked = ' checked="checked"'
			end
			html << '<label><input type="checkbox"'+checked+' class="ace" value="'+f.id.to_s+'" name="smsgroups[]"><span class="lbl"> '+f.name+'</span></label>&nbsp;&nbsp;'
		end
		raw html.join('')
	end
	def _depart_checkbox(departs,alreadexist='')
		alread_departs = alreadexist ? alreadexist.split(',') : Array.new
		html = []
		departs.each do |f|
			checked = ''
			if alread_departs.include?(f.id.to_s)
				checked = ' checked="checked"'
			end
			html << '<label><input type="checkbox"'+checked+' class="ace" value="'+f.id.to_s+'" name="departments[]"><span class="lbl"> '+f.name+'</span></label>&nbsp;&nbsp;'
		end
		raw html.join('')
	end
	def _sms_opeate(sms)
		html = []
		if _sms_status(sms.status) == '发送成功'
			return ''
		end
		html << '<div class="btn-group">'
		#send
		html << '<a class="btn btn-primary btn-xs" href="'+msgsend_sm_url(sms.id)+'"><i class="ace-icon fa fa-paper-plane-o  bigger-110 icon-only"></i></a>'
		#edit
		html << '<a class="btn btn-warning btn-xs" href="'+edit_sm_url(sms.id)+'"><i class="ace-icon fa fa-pencil  bigger-110 icon-only"></i></a>'
		#delete
		html << '<a class="btn btn-grey btn-xs" href="'+sm_url(sms.id)+'" data-remote="true" data-method="delete" data-confirm="确认删除？" rel="nofollow"><i class="ace-icon fa fa-trash-o bigger-110 icon-only"></i></a>'

		html << '</div>'
		raw html.join('')
	end
end