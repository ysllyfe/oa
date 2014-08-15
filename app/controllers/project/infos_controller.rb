#encoding:utf-8
class Project::InfosController < Project
	before_filter :searchbox
	def index
		@items = Item.all.order('ended asc,group_id asc,id desc')
	end
	def show
		@item = Item.find(params[:id])
	end



	def nav_search
		@item = Item.find_by(name: params[:name])
		redirect_to project_info_url(@item.id)
	end
	def controller_role
		if @logged_in_user.has_role?('like deal_')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like deal_`"
			redirect_to deny_url and return
		end
	end
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.info")
		@breadcrumbs << [t("sidebar.project.info"),project_infos_url]
	end
	def searchbox
		@searchbox_data = Item.all
	end
end