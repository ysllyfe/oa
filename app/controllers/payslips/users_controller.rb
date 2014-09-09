#encoding:utf-8
class Payslips::UsersController < Admin
	before_filter :set_submenu_and_breadcrumbs
	def index
		group = Group.where(system:1)
		@users = Array.new(group.count)
		@group = Array.new(group.count)
		group.each_with_index do |g,index|
			@group[index] = g
			@users[index] = {:try=>Array.new(),:notry=>Array.new(),:stop=>Array.new}
			users = User.where(group_id:g.id,injob:[1,2],softdelete:false).order('id ASC')
			users.each_with_index do |f,i|
				if f.injob == 2
					@users[index][:stop] << f
					next
				end
				if f.info.positive_at
					@users[index][:notry] << f
				else
					@users[index][:try] << f
				end
			end
		end
	end
	def show
		@user = User.find(params[:id])
		@wages = @user.wages.order('start_at asc')
	end
	def edit
		@user = User.find(params[:id])
		@wage = Wage.new
	end
	def update
		@user = User.find(params[:id])
		@wage = Wage.new
		@wage.user_id = @user.id
		@wage.start_at = params[:start_at]
		@wage.part_1 = params[:part_1]
		@wage.part_2 = params[:part_2]
		@wage.part_3 = params[:part_3]
		@wage.info = params[:info]
		@wage.save
		#render :text=>'success' and return
		redirect_to payslips_user_url(@user)
	end
	def del
		@wage = Wage.find(params[:id])
		@user_id = @wage.user_id
		@wage.delete
		redirect_to payslips_user_url(@user_id)
	end
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.payslip.wage")
		@breadcrumbs << [t("sidebar.payslip.wage"),payslips_users_url]
	end
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.payslip")
		@breadcrumbs << [t("sidebar.menu.payslip"),payslips_url]
	end
	def controller_role
		if !@logged_in_user.has_role?('payslips_check')
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`payslips_check`"
			redirect_to deny_url and return
		end
	end
end