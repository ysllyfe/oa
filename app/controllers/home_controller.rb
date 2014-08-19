#encoding:utf-8
class HomeController < Admin
	skip_before_filter :controller_role
	def index
		@articles = @logged_in_user.group.articles.where(is_checked: 1).order('id desc').limit(5)
		@notices = @logged_in_user.group.notices.where(checked:true).order('id desc').limit(5)
	end
	def role_deny
	end
	def set_controller_sidebar
	end
end