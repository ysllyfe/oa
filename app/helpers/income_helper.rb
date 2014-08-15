module IncomeHelper
	include TimeBase
	def _recent_month(url='',block="btn-block",num=7)
		html = []
		s = url.count('?')>0 ? '&' : '?'
		@time = Time.new
		colors = %w(btn-purple btn-default btn-primary btn-success  btn-pink btn-warning btn-info  btn-danger)
		(0..num).each do |n|
			addon = s
			name = _time_std(@time-n.month).month
			month = _month(@time-n.month)
			addon += 'btime=' + month.split('/')[0] + '&etime=' + month.split('/')[1]
			html << '<a href="'+url+addon+'" class="btn '+block+' '+colors[n]+'">'+name.to_s+'月</a>'
		end
		raw html.join('')
	end
	def yuan(s)
		number_to_currency(s,:unit=>'')
	end
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
		return raw "<span class=\"label label-info arrowed\">#{t('income.status.checked')}</span>" if income.checked == 1
		if income.submit == true || income.submit == 1
		#<span class="label label-success arrowed">Success</span>
			raw "<span class=\"label label-success arrowed\">#{t('income.status.submit')}</span>"
		else
			raw "<span class=\"label label-warning arrowed\">#{t("income.status.not_submit")}</span>"
		end

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