#encoding:utf-8
class Base < Admin
	def controller_role
		if @logged_in_user.has_role?('income_edit')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`income_edit`"
			redirect_to deny_url and return
		end
	end
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.item")
		@breadcrumbs << [t("sidebar.menu.item"),base_items_url]
	end
end