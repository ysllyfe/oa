#encoding:utf-8
class Project::FinanceController < Project
	def index
		@items = Item.all.order('ended asc,group_id asc,id desc')
	end


	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.finance")
		@breadcrumbs << [t("sidebar.project.finance"),'#']
	end
end