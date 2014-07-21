#encoding:utf-8
class Project::IcostsController < Project
	skip_before_filter :set_submenu_and_breadcrumbs
	def new
		@income_id = params[:income]
		@income = @logged_in_user.incomes.find(@income_id)
		if @income.blank?
			render :text=>'deny!' and return
		end
		@icost = FeeSell.new
		@url = project_icosts_url
		render "form",:layout=>'ajax'
	end
	def create
		@income_id = params[:income_id]
		@income = @logged_in_user.incomes.find(@income_id)
		if @income.blank?
			render :text=>'deny!' and return
		end
		@fee = FeeSell.new
		@fee.info = params[:fee_sell][:info]
		@fee.cost = params[:fee_sell][:cost]
		@income.fee_sells << @fee
		render :text=>'parent.location.reload();'
	end
	def edit
		@icost = FeeSell.find(params[:id])
		@income = @icost.income
		@income_id = @income.id
		@url = project_icost_url(@icost.id)
		render "form",:layout=>'ajax'
	end
	def update
		@icost = FeeSell.find(params[:id])
		@icost.update_attribute(:info,params[:fee_sell][:info])
		@icost.update_attribute(:cost,params[:fee_sell][:cost])
		render :text=>'parent.location.reload();'
	end
	def destroy
		@icost = FeeSell.find(params[:id])
		@icost.destroy
		_back()
	end
end