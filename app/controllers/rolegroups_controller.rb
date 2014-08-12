#encoding:utf-8
class RolegroupsController < Admin
	def controller_role
		if @logged_in_user.has_role?('role_assignment')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`role_assignment`"
			redirect_to deny_url and return
		end
	end
	def index
		@rolegroups = Rolegroup.all.order('id asc')
	end
	def users
		@users = User.where(injob: true).order('group_id asc,id asc')
		@rolegroup = Rolegroup.find(params[:id])
		@rolegroup_users = @rolegroup.users.collect { |e| e.id }
	end
	def user_ajax_change
		@rolegroup = Rolegroup.find(params[:id])
		@user = User.find(params[:userid])
		if(params[:m] == 'add')
			@rolegroup.users << @user
			#用户组改变，生新计算用户权限
			@user.reloadroles
		else
			@rolegroup.users.delete(@user)
			#用户组改变，生新计算用户权限
			@user.reloadroles
		end
		render :text=>"group '#{@rolegroup.name}' `#{params[:m]}` user #{@user.username}"
	end
	def role_ajax_change
		@rolegroup = Rolegroup.find(params[:id])
		@role = Role.find(params[:roleid])
		if(params[:m] == 'add')
			@rolegroup.roles << @role
		else
			@rolegroup.roles.delete(@role)
		end
		#组内权限发生改变，重新计算组内成员的权限
		@users = @rolegroup.users
		@users.each do |t|
			t.reloadroles
		end
		render :text=>"group '#{@rolegroup.name}' `#{params[:m]}` role #{@role.name}"
	end
	def show
		@rolegroup = Rolegroup.find(params[:id])
		@roles = Role.where(enable:true).order('`group` asc')
		@rolegroup_roles = @rolegroup.roles.collect{|x| x.id}
	end
	def new
		@rolegroup = Rolegroup.new
		render 'form',:layout=>'ajax'
	end
	def edit
		@rolegroup = Rolegroup.find(params[:id])
		render 'form',:layout=>'ajax'
	end

	def create
		@rolegroup = Rolegroup.new
		@rolegroup.name = params[:rolegroup][:name]
		@rolegroup.info = params[:rolegroup][:info]
		@rolegroup.save!
		render :text=>'parent.location.reload();' and return
	end
	def update
		@rolegroup = Rolegroup.find(params[:id])
		@rolegroup.update_attribute(:name,params[:rolegroup][:name])
		@rolegroup.update_attribute(:info,params[:rolegroup][:info])
		render :text=>'parent.location.reload();' and return
	end

	def set_controller_sidebar
		@breadcrumbs << ["系统管理",accounts_url]
		@breadcrumbs << ["角色组",rolegroups_url]
	end
end