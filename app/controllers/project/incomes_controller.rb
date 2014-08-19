#encoding:utf-8
class Project::IncomesController < Project
	def controller_role
		if @logged_in_user.has_role?('income_edit')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`income_edit`"
			redirect_to deny_url and return
		end
	end
	def index
		@incomes = @logged_in_user.incomes.where(checked:false).order('id desc')
	end
	def show
		#show 与original相同，只是模板不一样
		@factories = Factory.where(softdelete:false).order('id asc')
		@steeltypes = Steeltype.where(softdelete:false).order('id asc')
		@income = Income.find(params[:id])
		@trucks = @income.trucks
		@sells = @income.sells
		@fees = @income.fees
		@fee_sells = @income.fee_sells
		@cb = cb_count(@income)
		@profit = @income.profit
	end
	def original!
		#提交表单到审核
		@income = @logged_in_user.incomes.find(params[:id])
		@item = @income.item
		@profit = Profit.new
		@profit.weight = params[:weight]
		@profit.iweight = params[:yweight]
		@profit.price = params[:sell] #销售价格
		@profit.profits = params[:lr]
		@profit.item_name = @item.name
		@profit.item_id = @item.id
		@profit.time = @income.time
		@profit.info = ''
		if(@income.profit)
			@income.profit.delete
		end
		@income.profit = @profit
		@income.update_attribute(:submit,true)
		
		add_notification(@logged_in_user.username,'income_check',project_audit_index_url,"提交了新的利润表")
		
		redirect_to project_incomes_url and return
	end
	def original
		#show 与original相同，只是模板不一样
		@factories = Factory.where(softdelete:false).order('id asc')
		@steeltypes = Steeltype.where(softdelete:false).order('id asc')
		@income = Income.find(params[:id])
		@trucks = @income.trucks
		@sells = @income.sells
		@fees = @income.fees
		@fee_sells = @income.fee_sells
		@cb = cb_count(@income)

		@profit = @income.profit
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
		rebuild = false
		if @income.checked == 1
			rebuild = true
			item = Item.find(@income.item_id)
		end
		@income.profit.delete if @income.profit
		@income.delete
		if rebuild
			item_profit_rebuild(item)
		end
		render :text=>'window.location.reload();' and return
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),'#']
	end
end