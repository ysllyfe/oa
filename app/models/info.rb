#encoding:utf-8
class Info < ActiveRecord::Base
	self.table_name = "staff_infos"
	belongs_to :user,:foreign_key=>'user_id',dependent: :destroy
end