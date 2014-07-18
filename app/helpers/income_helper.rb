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
		if income.submit == true
		#<span class="label label-success arrowed">Success</span>
			raw "<span class=\"label label-success arrowed\">#{t('income.status.submit')}</span>"
		else
			raw "<span class=\"label label-warning arrowed\">#{t("income.status.not_submit")}</span>"
		end

	end
end