#encoding:utf-8
class Group < ActiveRecord::Base
	has_many :group_departments
	has_many :users
	has_and_belongs_to_many :articles
	has_and_belongs_to_many :notices
	def departments
		self.group_departments
	end
end