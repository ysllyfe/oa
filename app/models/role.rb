#encoding:utf-8
class Role < ActiveRecord::Base
	has_and_belongs_to_many :rolegroups,:association_foreign_key=>'rolepart_id'
end