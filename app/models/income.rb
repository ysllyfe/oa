#encoding:utf-8
class Income < ActiveRecord::Base
	self.table_name = "income_statements"
	belongs_to :user
	belongs_to :item
	has_many :trucks,:foreign_key => "income_statement_id",dependent: :destroy
	has_many :costs,:foreign_key => "income_statement_id",dependent: :destroy
	has_many :sells,:foreign_key => "income_statement_id",dependent: :destroy
	has_many :fees,:foreign_key => "income_statement_id",dependent: :destroy
	has_many :fee_sells,:foreign_key => "income_statement_id",dependent: :destroy
end