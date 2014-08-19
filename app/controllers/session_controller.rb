#encoding:utf-8
class SessionController < Admin
	skip_before_filter :login_required
	skip_before_filter :set_controller_sidebar
	skip_before_filter :controller_role
	skip_before_filter :set_skin
	skip_before_filter :notification_show
	def login
		#@type = rand(2)
		bgs = %w(16 28 38 66 112 113 125 6)

		@type = 0
		@bg = '/imgs/bg/'+bgs[rand(bgs.length)-1]+'.jpg'
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