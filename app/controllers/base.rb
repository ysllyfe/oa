#encoding:utf-8
class Base < Admin
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.item")
		@breadcrumbs << [t("sidebar.menu.item"),base_items_url]
	end
end