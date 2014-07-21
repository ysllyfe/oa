#encoding:utf-8
class Truck < ActiveRecord::Base
	self.table_name = "income_trucks"
	belongs_to :income,:foreign_key => "income_statement_id"
	has_many :costs,:foreign_key => "income_truck_id",dependent: :destroy
	before_destroy :set_income_rebuid
	after_save :set_income_rebuid
	private
	def set_income_rebuid
		self.income.update_attribute(:rebuild,true)
	end
end