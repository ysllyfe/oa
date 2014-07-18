#encoding:utf-8
class Income < ActiveRecord::Base
	self.table_name = "income_statements"
	belongs_to :user
	belongs_to :item
	has_many :trucks,:foreign_key => "income_statement_id"
end