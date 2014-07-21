#encoding:utf-8
class Project::FeesController < Project
	def index
		@income = @logged_in_user.incomes.find(params[:income])
		@item = @income.item
		@feetypes = FeeType.where(softdelete:false,spe:0).order('id desc')
		@feetypespe = FeeType.where(spe:1).first

		@fees = @income.fees.where("income_fee_type_id != ?",@feetypespe.id)
		@feespes = @income.fees.where("income_fee_type_id = ?",@feetypespe.id)
		@feesell = @income.fee_sells
	end

	def new
		@fee = Fee.new
		render 'form',:layout=>'ajax'
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),project_incomes_url]
	end
end