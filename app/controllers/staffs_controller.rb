#encoding:utf-8
class StaffsController < Staff
	def show
		@userid = params[:id]
		@user = User.find(@userid)
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.staff.injob")
		@breadcrumbs << ['员工档案',staffs_bases_url]
	end
end