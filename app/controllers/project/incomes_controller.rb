#encoding:utf-8
class Project::IncomesController < Project
	def index
		@incomes = @logged_in_user.incomes.where(checked:false).order('id desc')
	end

	def original
		@income = Income.find(params[:id])
		@trucks = @income.trucks
	end

	def new
		@income = Income.new
		@items = Item.where(softdelete:false,ended:false).order('id desc')
		@deliveruser = User.where(delivery:1,injob:1)
		render 'form'
	end

	def edit
		@income = @logged_in_user.incomes.find(params[:id])
		@items = Item.where(softdelete:false,ended:false).order('id desc')
		@deliveruser = User.where(delivery:1,injob:1)
		@income.users = @income.users.split(',')
		render 'form'
	end

	def create
		pam = params[:income]
		u = pam[:users].delete_if {|x| x==""}
		@income = Income.new
		@income.item_id = pam[:item_id]
		@income.time = pam[:time]
		@income.users = u.join(',')
		@logged_in_user.incomes << @income
		redirect_to project_trucks_url(:income=>@income.id) and return
	end

	def update
		pam = params[:income]
		u = pam[:users].delete_if {|x| x == "" }
		@income = @logged_in_user.incomes.find(params[:id])
		@income.update_attribute(:item_id,pam[:item_id])
		@income.update_attribute(:time,pam[:time])
		@income.update_attribute(:users,u.join(','))
		redirect_to project_trucks_url(:income=>@income.id) and return
	end

	def destroy
		@income = Income.find(params[:id])
		@income.destroy
		redirect_to project_incomes_url
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),'#']
	end
end