#encoding:utf-8
class ArticlesController < Admin
	before_filter :searchbox
	def index
		@articles = Article.all.order('')
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

	end

	def edit
		@article = Article.find_by(hash_id:params[:id])
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

	def destroy

	end


	private

	def searchbox
		@searchbox_data = Article.all.order('id ASC')
	end

  def sys_param_params
    params.require(:article).permit(:title,:code,:dateline,:tags)
  end

	def set_controller_sidebar
		@sidebar = t("sidebar.menu.system")
		@breadcrumbs << [t("sidebar.menu.system"),articles_url]
	end
end