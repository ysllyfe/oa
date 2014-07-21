#encoding:utf-8
class FeeType < ActiveRecord::Base
	self.table_name = "income_fee_types"
	has_many :fees,:foreign_key=>'income_fee_type_id'
end