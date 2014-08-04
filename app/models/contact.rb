#encoding:utf-8
class Contact < ActiveRecord::Base
	self.table_name = "staff_emergency_contacts"
	belongs_to :user,:foreign_key=>'user_id',dependent: :destroy
end