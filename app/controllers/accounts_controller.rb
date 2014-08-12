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
	def index
		@users = User.all.order('injob desc,id asc').page(params[:page]).per(15)
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