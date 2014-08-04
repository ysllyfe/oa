#encoding:utf-8
class Department < ActiveRecord::Base
	self.table_name = "staff_departments"
	belongs_to :user,:foreign_key=>'user_id',dependent: :destroy
	def group
		Group.find(self.group_id) || Group.new
	end

	def group_department
		GroupDepartment.find(self.group_department_id) || GroupDepartment.new
	end
end