#encoding:utf-8
class Smsgroup < ActiveRecord::Base
	self.table_name = "smsgroups"
	has_and_belongs_to_many :users
	#has_and_belongs_to_many :sms,:foreign_key=>'sms_info_id',dependent: :destroy
end