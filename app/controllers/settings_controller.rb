#encoding:utf-8
class SettingsController < Admin
	skip_before_filter :controller_role
	def index
	end

	def userconfig
		@name = params[:name].to_s
		@logged_in_user.config_global = @name,params[:value]
		render :text=>'window.location.reload();' and return
	end

	def set_controller_sidebar
		@breadcrumbs << ['设置',settings_url]
	end
end