#encoding:utf-8
class Education < ActiveRecord::Base
	self.table_name = "staff_educations"
	belongs_to :user,:foreign_key=>'user_id',dependent: :destroy
end