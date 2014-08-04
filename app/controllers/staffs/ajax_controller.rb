#encoding:utf-8
class Staffs::AjaxController < Staffbox
	skip_before_filter :set_submenu_and_breadcrumbs

	def search
		@user = User.find_by(username:params[:username])
		redirect_to staffs_basis_url(@user.id)
	end
	def departments_delete
		render :text=>''
	end
end