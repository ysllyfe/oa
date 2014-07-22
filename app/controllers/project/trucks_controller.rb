#encoding:utf-8
class Project::TrucksController < Project
	def index
		@income = Income.find(params[:income])
		@trucks = @income.trucks
		@truck = Truck.new
		if(!@truck.chartered)
			@truck.chartered = false
		end
		@factories = Factory.where(softdelete:false).order('id asc')
		@steeltypes = Steeltype.where(softdelete:false).order('id asc')
	end
	def new
		#ajax add type
		@cost = nil
		render '_type',:layout=>false
	end
	def edit
		@truck = Truck.find(params[:id])
		@income = @truck.income
		@trucks = @income.trucks
		@factories = Factory.where(softdelete:false).order('id asc')
		@steeltypes = Steeltype.where(softdelete:false).order('id asc')
		@costs = @truck.costs
		render "index"
	end
	def create
		@income_id = params[:income_id]
		@income = @logged_in_user.incomes.find(@income_id)
		_back('对不起，来源错误！') if @income.blank?

		new_truck
		redirect_to project_trucks_url(:income=>@income_id) and return
	end
	def update
		@income_id = params[:income_id]
		@income = @logged_in_user.incomes.find(@income_id)
		_back('对不起，来源错误！') if @income.blank?
		@truck = Truck.find(params[:id])
		@truck.destroy
		new_truck
		redirect_to project_trucks_url(:income=>@income_id) and return
	end
	def destroy
		@truck = Truck.find(params[:id])
		@id = @truck.id
		@income_id = @truck.income_statement_id
		@truck.destroy
		if(request.env['HTTP_REFERER'] == edit_project_truck_url(@id))
			redirect_to project_trucks_url(:income=>@income_id) and return
		else
			_back()
		end
		#redirect_to project_trucks_url(:income=>@income_id) and return
	end

	def new_truck
		@truck = Truck.new()

		if params[:_weight].blank?
			redirect_to project_trucks_url(:income=>@income_id) and return
		end
		@truck.weight = params[:_weight]
		@truck.s1 = params[:truck][:s1]
		@truck.s2 = params[:truck][:s2]
		@truck.s3 = params[:truck][:s3]
		if params[:truck][:chartered] == '1'
			@truck.chartered = 1
			@truck.price = 0
			@truck.cost = params[:_y_baoche_total]
		else
			@truck.chartered = 0
			@truck.price = params[:_m_baoche_price]
			@truck.cost = params[:_m_baoche_total]
		end
		@income.trucks << @truck
		length = params[:type].length
		length.times do |i|  
			unless params[:type][i].blank? || params[:fformat][i].blank? || params[:factory][i].blank? || params[:weight][i].blank? || params[:price][i].blank?
			then
				array = Hash.new
				#income_truck_id   income_statement_id   steeltype_id  format  factory_id  weight  price
				array[:income_truck_id] = @truck.id
				array[:income_statement_id] = @income_id
				array[:steeltype_id] = params[:type][i]
				array[:format] = params[:fformat][i]
				array[:factory_id] = params[:factory][i]
				array[:weight] = params[:weight][i]
				array[:price] = params[:price][i]
				array[:weight_unit] = params[:weight_unit][i]
				@cost = Cost.new(array)
				@cost.save
			end
		end  
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),project_incomes_url]
	end
end