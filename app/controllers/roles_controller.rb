#encoding:utf-8
class RolesController < Admin
	def controller_role
		if @logged_in_user.has_role?('role_assignment')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`role_assignment`"
			redirect_to deny_url and return
		end
	end


	def index
		@roles = Role.where(enable:true).order('`group` asc')
	end

	def new
		@role = Role.new
		render 'form',:layout=>'ajax'
	end

	def edit
		@role = Role.find(params[:id])
		render 'form',:layout=>'ajax'
	end

	def create
		@role = Role.new
		@role.name = params[:role][:name]
		@role.nickname = params[:role][:nickname]
		@role.group = params[:role][:group]
		@role.save!
		render :text=>'parent.location.reload();' and return
	end
	def update
		@role = Role.find(params[:id])
		@role.update_attribute(:name,params[:role][:name])
		@role.update_attribute(:nickname,params[:role][:nickname])
		@role.update_attribute(:group,params[:role][:group])
		render :text=>'parent.location.reload();' and return
	end
	
	def destroy
		@role = Role.find(params[:id])
		@role.update_attribute(:enable,false)
		redirect_to roles_url and return
	end
	def set_controller_sidebar
		@breadcrumbs << ["系统管理",accounts_url]
		@breadcrumbs << ["角色管理",roles_url]
	end
end