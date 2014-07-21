#encoding:utf-8
class Cost < ActiveRecord::Base
	self.table_name = "income_costs"
	belongs_to :truck,:foreign_key => "income_truck_id"
	belongs_to :income,:foreign_key=>"income_statement_id"
end