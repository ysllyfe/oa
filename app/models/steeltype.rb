#encoding:utf-8
class Steeltype < ActiveRecord::Base
	has_many :costs,:foreign_key=>'steeltype_id'
end