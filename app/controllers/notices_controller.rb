#encoding:utf-8
class NoticesController < Admin
	def index
		@notices = Notice.all.order('id desc').page(params[:page]).per(20)
	end
	def show
		@notice = Notice.find(params[:id])
		@notice.views = @logged_in_user
	end
	def new
	end
	def create
	end
	def edit
	end
	def update
	end
	def destroy
	end
	private 
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.notice")
		@breadcrumbs << [t("sidebar.menu.notice"),notices_url]
	end
end