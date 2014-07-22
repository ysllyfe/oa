#encoding:utf-8
class Profit < ActiveRecord::Base
	self.table_name = "income_profits"
	belongs_to :income,:foreign_key => "income_statement_id",dependent: :destroy
	belongs_to :item
end