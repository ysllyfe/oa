#encoding:utf-8
class SettingsController < Admin
	skip_before_filter :controller_role
	def index
	end
	def passwd!
		msg = 'success'
		status = 'success'
		render :text=>"render_error('#{msg}','#{status}');" and return
	end
	def userconfig
		@name = params[:name].to_s
		#@logged_in_user.config_auto = @name,params[:value]
		#网上使用这种方法时，在model里跳过了，存储变成了  key=>auto, value=>@name,params[:value]
		case @name
		when 'skin'
			@logged_in_user.config_skin = params[:value]
		end
		render :text=>'window.location.reload();' and return
	end

	def set_controller_sidebar
		@breadcrumbs << ['设置',settings_url]
	end
end