#encoding:utf-8
class Staffs::BasesController < Staff
	def index
	end


	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.staff.injob")
		@breadcrumbs << [t("sidebar.staff.injob"),staffs_bases_url]
	end
end