#encoding:utf-8
class Project::FeesController < Project
	def index
		@income = @logged_in_user.incomes.find(params[:income])
		@item = @income.item
		@feetypes = FeeType.where(softdelete:false,spe:0).order('id desc')
		@feetypespe = FeeType.where(spe:1).first

		@fees = @income.fees.where("income_fee_type_id != ?",@feetypespe.id)
		@feespes = @income.fees.where("income_fee_type_id = ?",@feetypespe.id)
		@feesells = @income.fee_sells
	end

	def new
		@income_id = params[:income]
		@spe = params[:spe]
		@income = @logged_in_user.incomes.find(@income_id)
		if @income.blank?
			render :text=>'deny!' and return
		end
		@fee = Fee.new
		@feetypes = FeeType.where(softdelete:false,spe:0).order('id desc')
		@spetype = FeeType.where(softdelete:false,spe:1).first
		render 'form',:layout=>'ajax'
	end

	def edit
		@fee = Fee.find(params[:id])
		@income_id = @fee.income_statement_id
		@income = @logged_in_user.incomes.find(@income_id)
		if @income.blank?
			render :text=>'deny!' and return
		end
		@feetypes = FeeType.where(softdelete:false,spe:0).order('id desc')
		@spetype = FeeType.where(softdelete:false,spe:1).first
		if(@spetype.id == @fee.income_fee_type_id)
			@spe = 'true'
		end
		render 'form',:layout=>'ajax'
	end

	def create
		@income_id = params[:income_id]
		@income = @logged_in_user.incomes.find(@income_id)
		if @income.blank?
			render :text=>'deny!' and return
		end
		@fee = Fee.new
		@fee.income_fee_type_id = params[:fee][:income_fee_type_id]
		@fee.info = params[:fee][:info]
		@fee.cost = params[:fee][:cost]
		@income.fees << @fee
		render :text=>'parent.location.reload();'
	end

	def update
		@fee = Fee.find(params[:id])
		@fee.update_attribute(:income_fee_type_id,params[:fee][:income_fee_type_id])
		@fee.update_attribute(:info,params[:fee][:info])
		@fee.update_attribute(:cost,params[:fee][:cost])
		render :text=>'parent.location.reload();'
	end

	def destroy
		@fee = Fee.find(params[:id])
		@fee.destroy
		_back()
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),project_incomes_url]
	end
end