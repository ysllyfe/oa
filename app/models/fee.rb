#encoding:utf-8
class Fee < ActiveRecord::Base
	self.table_name = "income_fees"
	belongs_to :income,:foreign_key=>"income_statement_id"
end