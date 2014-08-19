#encoding:utf-8
class SmsController < Admin
	def index
		@sms = Sms.all.order('id desc').page(params[:page]).per(10)
	end
	def new
		@sm = Sms.new
		@sms_obj = SmsNow.new
		@num = @sms_obj.infoSMSAccount.to_i
		@sysgroups = Group.where(system:true).order('id asc')
		@smsgroups = Smsgroup.all.order('id asc')
	end
	def edit
		@sm = Sms.find(params[:id])
		@sms_obj = SmsNow.new
		@num = @sms_obj.infoSMSAccount.to_i
		@sysgroups = Group.where(system:true).order('id asc')
		@smsgroups = Smsgroup.all.order('id asc')
	end
	def create
		@sm = Sms.new
		@sm.info = params[:info]
		@sm.departments = params[:departments] ? params[:departments].join(',') : ''
		@sm.smsgroups = params[:smsgroups] ? params[:smsgroups].join(',') : ''
		@sm.user_id = @logged_in_user.id
		@sm.status = 'notsend'
		@sm.save!
		add_notification(@logged_in_user.username,'sms_check',sms_url,"提交了短信")
		redirect_to sms_url and return
	end
	def update
		@sm = Sms.find(params[:id])
		@sm.update_attribute(:info,params[:info])
		departments = params[:departments] ? params[:departments].join(',') : ''
		smsgroups = params[:smsgroups] ? params[:smsgroups].join(',') : ''
		@sm.update_attribute(:departments,departments)
		@sm.update_attribute(:smsgroups,smsgroups)
		redirect_to sms_url and return
	end
	def msgsending
		if !@logged_in_user.has_role?('sms_check')
			render :text=>'你没有对应的权限访问这个页面，对应的用户权限为`sms_check`' and return
		end
		@sm = Sms.find(params[:id])
		if @sm.status == 'Command complateted successfully'
			render :text=>'对应的短信已经发过了，请不要重复发送。' and return
		end
		phones = departs_phones = smsgroup_phones = []
		if !@sm.departments.blank?
			user = User.where(injob:true,group_department_id:@sm.departments.split(','))
			departs_phones = user.collect{|u| u.phone}
		end
		if !@sm.smsgroups.blank?
			smsgroups = Smsgroup.where("id in (?)",@sm.smsgroups.split(',')).order('id asc')
			smsgroups.each do |f|
				smsgroup_phones = smsgroup_phones + f.users.collect{|u| u.phone}
			end
		end
		phones = departs_phones + smsgroup_phones
		phones = phones.uniq.compact
		if phones.blank?
			render :text=>'对不起，选择的对应组里面没有用户，或是用户手机不存在' and return
		end
		@sms_obj = SmsNow.new
		response = @sms_obj.sendSMS(phones,@sm.info,3,0)
		@sm.update_attribute(:status,response)
		msg = response == 'Command complateted successfully' ? '短信成功发送' : response
		render :text=>msg
	end
	def msgsend
		if !@logged_in_user.has_role?('sms_check')
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`sms_check`"
			redirect_to deny_url and return
		end
		@sm = Sms.find(params[:id])
		@sysgroups = Group.where(system:true).order('id asc')
		@sms_obj = SmsNow.new
		@smsgroups = Smsgroup.all.order('id asc')
		@num = @sms_obj.infoSMSAccount.to_i
	end
	def destroy
		if !@logged_in_user.has_role?('sms_check')
			render :text=>'alert("对不起，你没有对应的权限，对应的用户权限为`sms_check`")' and return
		end
		@sm = Sms.find(params[:id])
		@sm.destroy
		render :text=>'window.location.reload();'
	end
	private
	def controller_role
		if @logged_in_user.has_role?('like sms_')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like sms_`"
			redirect_to deny_url and return
		end
	end
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.sms")
		@breadcrumbs << [t("sidebar.menu.sms"),sms_url]
	end
end