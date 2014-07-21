#encoding:utf-8
class FeeSell < ActiveRecord::Base
	self.table_name = "income_fee_sells"
	belongs_to :income,:foreign_key=>"income_statement_id"
	belongs_to :fee_typ,:foreign_key=>"income_fee_type_id"
end