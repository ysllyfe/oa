#encoding:utf-8
class FeeSell < ActiveRecord::Base
	self.table_name = "income_fee_sells"
	belongs_to :income,:foreign_key=>"income_statement_id"
end