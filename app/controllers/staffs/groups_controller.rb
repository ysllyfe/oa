#encoding:utf-8
class Staffs::GroupsController < Staffbox
	def index
		@groups = Group.where(system:1)
	end


	def new
		@depart = GroupDepartment.new
		@depart.group_id = params[:group_id]
	end
	def create
		@depart = GroupDepartment.new(params[:group_department].permit!)
		@depart.save!
		redirect_to staffs_groups_url
	end

	def edit
		@depart = GroupDepartment.find(params[:id])
	end

	def update
		@depart = GroupDepartment.find(params[:id])
		@depart.update_attributes(params[:group_department].permit!)
		redirect_to staffs_groups_url
	end
	def destroy
		@depart = GroupDepartment.find(params[:id])
		@depart.delete
		redirect_to staffs_groups_url
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.staff.group")
		@breadcrumbs << [t("sidebar.staff.group"),staffs_groups_url]
	end

	def controller_role
		if @logged_in_user.has_role?('staff_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`staff_check`"
			redirect_to deny_url and return
		end
	end
end