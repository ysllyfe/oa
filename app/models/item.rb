#encoding:utf-8
class Item < ActiveRecord::Base
	def group
		Group.where(id:self.group_id).first
	end
end