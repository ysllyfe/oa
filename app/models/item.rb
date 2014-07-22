#encoding:utf-8
class Item < ActiveRecord::Base
	has_many :incomes
	has_many :profits
	def group
		Group.where(id:self.group_id).first
	end
end