#encoding:utf-8
class Sms < ActiveRecord::Base
	self.table_name = "sms_infos"
	#has_and_belongs_to_many :smsgroups,:foreign_key=>'sms_info_id',dependent: :destroy

	def user
		if self.user_id
			return User.find(self.user_id)
		end
		return User.new
	end
end