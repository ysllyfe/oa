#encoding:utf-8
class Rolegroup < ActiveRecord::Base
	self.table_name = "roleparts"
	has_and_belongs_to_many :roles,:foreign_key=>'rolepart_id'
	has_and_belongs_to_many :users,:foreign_key=>'rolepart_id'
end