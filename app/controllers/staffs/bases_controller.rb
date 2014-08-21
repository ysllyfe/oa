#encoding:utf-8
class Staffs::BasesController < Staffbox
	before_filter :searchbox
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
	def allchecked
		if @logged_in_user.has_role?('staff_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`staff_check`"
			redirect_to deny_url and return
		end
		@user = User.find(params[:id])
		@user.update_attribute(:needcheck,false)
		redirect_to needcheck_staffs_bases_url and return
	end
	def needcheck
		if @logged_in_user.has_role?('staff_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`staff_check`"
			redirect_to deny_url and return
		end
		@submenu = t("sidebar.staff.audit")
		@breadcrumbs << [t("sidebar.staff.audit"),needcheck_staffs_bases_url]
		@users = User.where(injob:[1,2],softdelete:false,needcheck:true).order('updated_at desc').page(params[:page]).per(20)
	end
	def outjob
		if @logged_in_user.has_role?('staff_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`staff_check`"
			redirect_to deny_url and return
		end
		@submenu = t("sidebar.staff.outwork")
		@breadcrumbs << [t("sidebar.staff.outwork"),outjob_staffs_bases_url]
		@users = User.where(injob:0,softdelete:false).order('id desc').page(params[:page]).per(20)
	end
	def show
		@user = User.find(params[:id])
		@infos = @user.infos
		#@departments = @user.departments.where(ischecked:true).order('id asc')
		@departments = @user.departments.all.order('id asc')
		@educations = @user.educations.all.order('id asc')
		@families = @user.families.all.order('id asc')
		@contacts = @user.contacts.all.order('id asc')
		@attachments = @user.attachments
	end
	private
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.staff.injob")
		@breadcrumbs << [t("sidebar.staff.injob"),staffs_bases_url]
	end

	def controller_role
		if @logged_in_user.has_role?('like staff_')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like staff_`"
			redirect_to deny_url and return
		end
	end

	def searchbox
		@searchbox_data = User.where(injob:true).order('id ASC')
	end
end