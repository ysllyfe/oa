# encoding: utf-8
module NotificationBase
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