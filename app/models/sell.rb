#encoding:utf-8
class Sell < ActiveRecord::Base
	self.table_name = "income_sells"
	belongs_to :income,:foreign_key=>"income_statement_id"
end