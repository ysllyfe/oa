# encoding: utf-8
module NotificationBase
	def send_sms_notification_by_group(group_id,msg,url)
		users = User.where("group_id in (?) and injob = 1",group_id)
		phones = users.collect{|u| u.phone}
		if phones.blank?
			return ''
		end
		info = []
		info << msg
		info << "，查看 #{url}"
		@sms_obj = SmsNow.new
		response = @sms_obj.sendSMS(phones,info.join(''),3,0)
	end
	def add_notification(from_user,to_role='',url='',msg)
		role = Role.find_by(name:to_role)
		if(role)
			users = role.users
			notice = "#{from_user}"+msg
			users.each do |f|
				if f.username == from_user
					#不通知自己
				else
					notification = Notification.new()
					notification.info = notice
					notification.url = url
					notification.user_id = f.id
					notification.save!
				end
			end
		end
	end
end