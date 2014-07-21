#encoding:utf-8
class Factory < ActiveRecord::Base
	has_many :costs,:foreign_key=>'factory_id'
end