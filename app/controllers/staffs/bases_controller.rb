#encoding:utf-8
class Staffs::BasesController < Staffbox
	before_filter :searchbox
	def index
		group = Group.where(system:1)
		@users = Array.new(group.count)
		@group = Array.new(group.count)
		group.each_with_index do |g,index|
			@group[index] = g
			@users[index] = {:try=>Array.new(),:notry=>Array.new()}
			users = User.where(group_id:g.id,injob:true).order('id ASC')
			users.each_with_index do |f,i|
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
		@departments = @user.departments.where(ischecked:true).order('id asc')
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


	def searchbox
		@searchbox_data = User.where(injob:true).order('id ASC')
	end
end