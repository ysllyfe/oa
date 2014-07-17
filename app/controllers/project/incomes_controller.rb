#encoding:utf-8
class Project::IncomesController < Project
	def index
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),'#']
	end
end