#encoding:utf-8
class Admin < ApplicationController
	before_filter :login_required
	before_filter :set_sidebar_breadcrumbs
	before_filter :set_controller_sidebar

	rescue_from ActionView::MissingTemplate,:with => :tmp_tpl
	def _back(msg=nil)
		flash[:notice] = msg
		redirect_to request.env['HTTP_REFERER'] and return
	end
	private
	def set_sidebar_breadcrumbs
		#breadcrumbs type
		# title,url,icon
		@breadcrumbs = []
		@breadcrumbs << [t("setting.home"),root_url,'<i class="ace-icon fa fa-home home-icon"></i>']
		#sidebar submenu
		@sidebar = t("setting.home")
		@submenu = t("setting.home")
	end

	def tmp_tpl
		render :text=>'MissingTemplate' and return
	end

end