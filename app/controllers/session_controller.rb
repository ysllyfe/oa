#encoding:utf-8
class SessionController < Admin
	skip_before_filter :login_required
	skip_before_filter :set_controller_sidebar
	def login
		@type = rand(2)
		@user = User.new
		render :layout=>'session' and return
	end
	def login!
		code = User.authenticate(params[:username],params[:password])
		if(code[:code] == 200)
			self.logged_in_user = code[:user]
			redirect_to root_url and return
		else
			_back(t("login.error_#{code[:code]}"))
		end
	end
end