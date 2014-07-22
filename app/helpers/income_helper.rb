module IncomeHelper
	def _delvery_user(users)
		return '' if users.blank?
		u = []
		users.split(',').each do |f|
			u << User.find(f).username
		end
		u.join(' , ')
	end
	def _income_status(income)
		#checked
		return raw "<span class=\"label label-info arrowed\">#{t('income.status.checked')}</span>" if income.checked == true
		if income.submit == true || income.submit == 1
		#<span class="label label-success arrowed">Success</span>
			raw "<span class=\"label label-success arrowed\">#{t('income.status.submit')}</span>"
		else
			raw "<span class=\"label label-warning arrowed\">#{t("income.status.not_submit")}</span>"
		end

	end
	def _round(s,num=4)
		s.to_s.to_f.round(num)
	end

	def _income_step(income_id,steps,step=1)
		html = ''
		html += '<div data-target="#step-container" id="fuelux-wizard">'
		html += '<ul class="wizard-steps">'
		steps.each do |f|
			url = f[1]
			url["_replays_"] = income_id.to_s
			active = step == f[2] ? 'active' : ''
			html += "<li class='#{active}'>"
			html += '<a class="step" href="'+url+'">'+f[2].to_s+'</a>'
			html += '<a class="title" href="'+url+'">'+f[0]+'</a>'
			html += '</li>'
		end
		html += '</ul></div>'
		raw html
	end
end