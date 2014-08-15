#encoding:utf-8
class HomeController < Admin
	skip_before_filter :controller_role
	def index
		
	end
	def role_deny
	end
	def set_controller_sidebar
	end
end