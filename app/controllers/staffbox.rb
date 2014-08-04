#encoding:utf-8
class Staffbox < Admin
	before_filter :set_submenu_and_breadcrumbs
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.staff")
		@breadcrumbs << [t("sidebar.menu.staff"),'#']
	end
end