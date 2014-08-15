#encoding:utf-8
class ItemPayment < ActiveRecord::Base
	self.table_name = "item_payments"
	belongs_to :item,:foreign_key=>'item_id',dependent: :destroy
end