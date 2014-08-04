#encoding:utf-8
class NoticeView < ActiveRecord::Base
	def user
		User.find self.user_id if self.user_id
	end
end