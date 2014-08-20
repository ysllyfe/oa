#encoding:utf-8
module UserHelper
	def _security_form(user)
		html = []
		radio_security_true = user.security == true ? 'checked="checked"' : ''
		span_security_true = user.security == true ? 'display:block' : 'display:none'
		radio_security_false = user.security == false ? 'checked="checked"' : ''
		sec_start = user.sec_start ? user.sec_start.to_s(:ymd) : ''
		sec_end = user.sec_end ? user.sec_end.to_s(:ymd) : ''
		html << '<label><input type="radio" '+radio_security_false+' value="false" name="security" class="ace switch-security"><span class="lbl"> 未买 </span></label>'
    html << '<label><input type="radio" '+radio_security_true+' value="true" name="security" class="ace switch-security"><span class="lbl"> 已买 </span></label>'
    html << '<p class="help-block switch-security-box" style="'+span_security_true+'">开始时间：<input type="text" data-date-format="yyyy-mm-dd" class="input-small date-picker" name="sec_start" value="'+ sec_start +'">'
   	html << '结束时间：<input type="text" data-date-format="yyyy-mm-dd" class="input-small date-picker" name="sec_end" value="'+ sec_end +'"> </p>'
   	raw html.join("")
	end
	def _labor_form(user)
		html = []
		radio_labor_true = user.labor == true ? 'checked="checked"' : ''
		span_labor_true = user.labor == true ? 'display:block' : 'display:none'
		radio_labor_false = user.labor == false ? 'checked="checked"' : ''
		lab_start = user.lab_start ? user.lab_start.to_s(:ymd) : ''
		lab_end = user.lab_end ? user.lab_end.to_s(:ymd) : ''
		html << '<label><input type="radio" '+radio_labor_false+' value="false" name="labor" class="ace switch-labor"><span class="lbl"> 未签 </span></label>'
    html << '<label><input type="radio" '+radio_labor_true+' value="true" name="labor" class="ace switch-labor"><span class="lbl"> 已签 </span></label>'
    html << '<p class="help-block switch-labor-box" style="'+span_labor_true+'">开始时间：<input type="text" data-date-format="yyyy-mm-dd" class="input-small date-picker" name="lab_start" value="'+ lab_start +'">'
   	html << '结束时间：<input type="text" data-date-format="yyyy-mm-dd" class="input-small date-picker" name="lab_end" value="'+ lab_end +'"> </p>'
   	raw html.join("")
	end
	def _birth_form(user)
		html = []
		radio_birth = user.birth.blank? ? '' : 'checked="checked"'
		span_birth = user.birth.blank? ? 'display:none' : 'display:inline'
		radio_lunar = user.lunar.blank? ? '' : 'checked="checked"'
		span_lunar = user.lunar.blank? ? 'display:none' : 'display:inline'
		html << '<label><input type="radio" '+radio_birth+' class="ace switch-birth" value="阳历" name="birthday"><span class="lbl"> 阳历 </span></label>'
		html << '<label><input type="radio" '+radio_lunar+' class="ace switch-birth" value="农历" name="birthday"><span class="lbl"> 农历 </span></label>'
		html << '<span id="mybirth" class="switch-birth-box" style="'+span_birth+'"><input type="text" value="'+user.birth+'"  data-date-format="mm-dd" class="input-small date-picker" name="birth">(不考虑年份)</span>'
  	html << '<span id="mylunar" class="switch-birth-box" style="'+span_lunar+'"><input type="text" value="'+user.lunar+'" class="input-small" name="lunar">（格式如下：正月初一,正月十一，二月二十二）</span>'
  	raw html.join("")
	end
	def _birth(user)
		return user.info.lunar if !user.info.lunar.blank?
		return user.staff.birth
	end
	def _birth_info(info)
		return info.lunar if !info.lunar.blank?
		return info.birth
	end
	def _job_status(injob)
		if injob == 0
			'离职'
		elsif injob == 1
			'在职'
		elsif injob == 2
			'停薪留职'
		end
	end
	def _staff_operate(m,options={})
		url = ''
		case m.class.to_s
		when 'Department'
			url = staffs_ajax_departments_url(:id=>m.id)
		when 'Education'
			url = staffs_ajax_edu_url(:id=>m.id)
		when 'Contact'
			url = staffs_ajax_contact_url(:id=>m.id)
		when 'Family'
			url = staffs_ajax_member_url(:id=>m.id)
		when 'Info'
			url = staffs_ajax_info_url(:id=>m.id)
		end

		#.ischecked,'delete'=>staffs_ajax_departments_url(:id=>depart.id)
		html = []
		if m.ischecked
			html << '<a href="'+url+'" class="btn btn-xs btn-danger" data-method="delete" data-remote="true" data-confirm="确认删除？" rel="nofollow">'
			html << '<i class="ace-icon fa fa-trash-o bigger-120"></i>'
			html << '</a>'
		else
			#audit and destroy
			html << '<a href="'+url+'" class="btn btn-xs btn-info" data-method="put" data-confirm="确认审核？" data-remote="true" rel="nofollow">'
			html << '<i class="ace-icon fa fa-check-square-o bigger-120"></i>'
			html << '</a>'
			html << '<a href="'+url+'" class="btn btn-xs btn-danger" data-method="delete" data-confirm="确认删除？" data-remote="true" rel="nofollow">'
			html << '<i class="ace-icon fa fa-trash-o bigger-120"></i>'
			html << '</a>'
		end
		raw html.join
	end
end