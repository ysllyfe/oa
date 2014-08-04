#encoding:utf-8
class Family < ActiveRecord::Base
	self.table_name = "staff_family_members"
	belongs_to :user,:foreign_key=>'user_id',dependent: :destroy
end