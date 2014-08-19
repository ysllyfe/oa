#encoding:utf-8
class NotificationsController < Admin
	skip_before_filter :controller_role
	def index
		@notifications = Notification.where(user_id:@logged_in_user.id).page(params[:page]).per(20)
	end
	def show
		notification = Notification.find(params[:id])
		if notification.user_id == @logged_in_user.id
			url = notification.url
			notification.delete
			redirect_to url and return
		end
		render :text=>'error'
	end
	def set_controller_sidebar
		@breadcrumbs << ['通知单',notifications_url]
	end
end