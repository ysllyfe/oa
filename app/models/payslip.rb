#encoding:utf-8
class Payslip < ActiveRecord::Base
	has_many :payslip_details
	def name
		self.time.to_s(:yy) + '年' + self.time.to_s(:mm) + '月工资单'
	end
end