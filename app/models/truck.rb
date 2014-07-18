#encoding:utf-8
class Truck < ActiveRecord::Base
	self.table_name = "income_trucks"
	belongs_to :income
end