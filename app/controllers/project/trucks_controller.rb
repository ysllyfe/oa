#encoding:utf-8
class Project::TrucksController < Project
	def index
		@income = Income.find(params[:income])
		@trucks = @income.trucks
		@truck = Truck.new
		@factories = Factory.where(softdelete:false).order('id asc')
		@steeltypes = Steeltype.where(softdelete:false).order('id asc')
	end
	def new
		#ajax add type
		render '_type',:layout=>false
	end
	def edit
		@truck = Truck.find(params[:id])
	end
	def create
	end
	def update
	end
	def destroy
	end
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),project_incomes_url]
	end
end