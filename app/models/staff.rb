#encoding:utf-8
class Staff < ActiveRecord::Base
	self.table_name = "staffs"
	belongs_to :user,:foreign_key=>'user_id',dependent: :destroy
end