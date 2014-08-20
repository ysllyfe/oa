#encoding:utf-8
class AccountsController < Admin
	before_filter :search_box_data
	def controller_role
		if @logged_in_user.has_role?('role_assignment')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`role_assignment`"
			redirect_to deny_url and return
		end
	end
	def search
		@user = User.find_by(username: params[:username])
		redirect_to accounts_url(:id=>@user.id)
	end
	def rolegroups
		@user = User.find(params[:id])
	end
	def roles
		@user = User.find(params[:id])
		@roles = Role.where(enable:true).order('`group` asc')
		@user_roles = @user.roles.collect { |e| e.id }
	end
	def role_ajax_change
		@user = User.find(params[:id])
		@role = Role.find(params[:roleid])
		if(params[:m] == 'add')
			@user.roles << @role
		else
			@user.roles.delete(@role)
		end
		render :text=>"user '#{@user.username}' `#{params[:m]}` role #{@role.name}"
	end
	def index
		@tab = params[:tab] ? params[:tab] : 'injob'
		case @tab
		when 'injob'
			injob = 1
		when 'stop'
			injob = 2
		when 'outjob'
			injob = 0
		end
		@users = User.where(softdelete:0,injob:injob).order('id asc').page(params[:page]).per(10)
		if(params[:id])
			@users = @users.where(id:params[:id])
		end
	end

	def new
	end
	def edit
	end
	def create
	end
	def update
	end
	def delete
		@user = User.find(params[:id])
		@user.update_attribute(:softdelete,true)
		@user.update_attribute(:injob,0)
		@user.update_attribute(:enabled,0)
		@user.update_attribute(:password,SecureRandom.hex(4))
		render :text=>'window.location.reload();' and return
	end
	def destroy
		@user = User.find(params[:id])
		if(@user.enabled == false)
			@user.update_attribute(:enabled,true)
		else
			@user.update_attribute(:enabled,false)
		end
		_back
	end

	def search_box_data
		@searchbox_data = User.all
	end
	def set_controller_sidebar
		@breadcrumbs << ["系统管理",accounts_url]
		@breadcrumbs << ["用户管理",accounts_url]
	end
end