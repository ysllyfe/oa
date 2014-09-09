#encoding:utf-8
class ArticlesController < Admin
	before_filter :searchbox
	before_filter :action_role,:except=>[:index,:search,:show]
	def index
		if(@logged_in_user.has_role?('like article_'))
			@articles = Article.all.order('id desc').page(params[:page]).per(20)
		else
			@articles = @logged_in_user.group.articles.where(is_checked: 1).page(params[:page]).per(20)
		end
	end

	def search
		@article = Article.find_by(title:params[:title])
		redirect_to article_url(@article.hash_id)
	end

	def show
		@article = Article.find_by(hash_id:params[:id])
		@article.views = @logged_in_user
	end
	def new
		@article = Article.new
		@groups = Group.where(system:1)
	end

	def create
		@article = Article.new(sys_param_params)
		@article.user_id = @logged_in_user.id
		@article.save!
		@article.set_group(params[:article][:group_id])
		@article.content = params[:editorValue]

		add_notification(@logged_in_user.username,'article_check',articles_url,"提交了制度#{@article.title}")

		redirect_to articles_url and return
	end

	def edit
		@article = Article.find_by(hash_id:params[:id])
		if @article.is_checked == 1 && !@logged_in_user.has_role?('article_check')
			flash[:error] = "文章已审核，你没有对应的权限，对应的用户权限为`article_check`"
			redirect_to deny_url and return false
		end
		@groups = Group.where(system:1)
		@article.group_id = @article.groups.collect{|x| x.id}
	end

	def update
		@article = Article.find(params[:id])
		@article.update_attributes(sys_param_params)
		@article.set_group(params[:article][:group_id])
		@article.content = params[:editorValue]
		redirect_to articles_url and return
	end

	def check
		if !@logged_in_user.has_role?('article_check')
			flash[:error] = "你没有对应的权限，对应的用户权限为`article_check`"
			redirect_to deny_url and return false
		end
		@article = Article.find_by(hash_id:params[:id])
		if @article.is_checked == 1
			@article.update_attribute(:is_checked,0)
		else
			group = @article.groups.collect{|x| x.id}
			msg = "新制度：" + @article.title
			url = article_url(@article)
			send_sms_notification_by_group(group,msg,url)
			@article.update_attribute(:is_checked,1)
		end
		redirect_to articles_url and return
	end
	def destroy
		@article = Article.find_by(hash_id:params[:id])
		if @article.is_checked == 1
			if !@logged_in_user.has_role?('article_check')
				flash[:error] = "文章已审核，你没有对应的删除权限，对应的用户权限为`article_check`"
				redirect_to deny_url and return false
			end
		end
		@article.destroy!
		redirect_to articles_url and return
	end


	private

	def searchbox
		if(@logged_in_user.has_role?('like article_'))
			@searchbox_data = Article.all.order('id desc')
		else
			@searchbox_data = @logged_in_user.group.articles.where(is_checked: 1)
		end
	end
	def action_role
		if !@logged_in_user.has_role?('like article_')
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like article_`"
			redirect_to deny_url and return false
		end
	end
	def controller_role
	end

  def sys_param_params
    params.require(:article).permit(:title,:code,:dateline,:tags)
  end

	def set_controller_sidebar
		@sidebar = t("sidebar.menu.system")
		@breadcrumbs << [t("sidebar.menu.system"),articles_url]
	end
end