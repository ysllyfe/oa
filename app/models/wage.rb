#encoding:utf-8
class Wage < ActiveRecord::Base
	belongs_to :user
	after_save :change_wage
	after_destroy :change_wage
	def change_wage
		#pre_wage = Wage.where("start_at < ? and user_id = ? ",self.start_at,self.user_id).order('start_at desc').first
		#p pre_wage
		#next_wage = Wage.where("start_at > ? and user_id = ? ",self.start_at,self.user_id).order('start_at asc').first
		#p next_wage
	end
end