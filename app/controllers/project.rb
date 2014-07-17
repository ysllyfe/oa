#encoding:utf-8
class Project < Admin
	before_filter :set_submenu_and_breadcrumbs
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.project")
		@breadcrumbs << [t("sidebar.menu.project"),'#']
	end
end