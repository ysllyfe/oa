#encoding:utf-8
class NoticesController < Admin
	skip_before_filter :controller_role
	before_filter :checkedit,:only=>[:new,:edit,:create,:update]
	before_filter :checkadmin,:only=>[:destroy,:check]
	def check
		@notice = Notice.find(params[:id])
		if @notice.checked == true
			@notice.update_attribute(:checked,false)
		else
			@notice.update_attribute(:checked,true)
		end
		render :text=>'window.location.reload();'
	end
	def index
		if params[:checked] && params[:checked] == 'true'
			@notices = Notice.where(checked:false).order('id desc').page(params[:page]).per(10)
		else
			if @logged_in_user.has_role?('like notice_')
				@notices = Notice.where(checked:true).order('id desc').page(params[:page]).per(10)
			else
				@notices = @logged_in_user.group.notices.where(checked:true).order('id desc').page(params[:page]).per(10)
			end
		end
	end
	def show
		@notice = Notice.find(params[:id])
		@notice.views = @logged_in_user
	end
	def new
		@notice = Notice.new
		@groups = Group.where(system:1)
	end
	def create
		@notice = Notice.new
		@notice.title = params[:notice][:title]
		@notice.info = params[:editorValue]
		@notice.user_id = @logged_in_user.id
		@notice.save!
		@notice.set_group(params[:notice][:group_id])
		add_notification(@logged_in_user.username,'notice_check',notices_url(:checked=>'true'),"提交了通知#{@notice.title}")
		redirect_to notices_url
	end
	def edit
		@notice = Notice.find(params[:id])
		@groups = Group.where(system:1)
		@notice.group_id = @notice.groups.collect{|x| x.id}
		if(@notice.checked == true)
			if @logged_in_user.has_role?('notice_check')
			else
				flash[:error] = "对应的页面已经审核，你没有对应的权限去修改，对应权限为`notice_check`"
				redirect_to deny_url and return
			end
		end
	end
	def update
		@notice = Notice.find(params[:id])
		@notice.set_group(params[:notice][:group_id])
		@notice.update_attribute(:info,params[:editorValue])
		@notice.update_attribute(:title,params[:notice][:title])
		redirect_to notices_url
	end
	def destroy
		@notice = Notice.find(params[:id])
		@notice.destroy
		redirect_to notices_url and return
	end
	private 
	def checkedit
		if @logged_in_user.has_role?('like notice_')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like notice_`"
			redirect_to deny_url and return
		end
	end
	def checkadmin
		if @logged_in_user.has_role?('notice_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`notice_check`"
			redirect_to deny_url and return
		end
	end
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.notice")
		@breadcrumbs << [t("sidebar.menu.notice"),notices_url]
	end
end