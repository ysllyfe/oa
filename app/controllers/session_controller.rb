#encoding:utf-8
class SessionController < Admin
	skip_before_filter :login_required
	skip_before_filter :set_controller_sidebar
	skip_before_filter :controller_role
	def login
		@type = rand(2)
		@user = User.new
		render :layout=>'session' and return
	end
	def login!
		code = User.authenticate(params[:username],params[:password])
		if(code[:code] == 200)
			self.logged_in_user = code[:user]
			logged_in_user.update_attribute(:last_login_at,Time.now)
			redirect_to root_url and return
		else
			_back(t("login.error_#{code[:code]}"))
		end
	end

	def logout
		reset_session
    redirect_to '/session/login' and return
	end
end