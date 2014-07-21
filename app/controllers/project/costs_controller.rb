#encoding:utf-8
class Project::CostsController < Project
	def index
		@income = @logged_in_user.incomes.find(params[:income])
		@item = @income.item
		@factories = Factory.where(softdelete:false).order('id asc')
		@steeltypes = Steeltype.where(softdelete:false).order('id asc')
		@cost = Cost.new()
		@costs = @income.costs
		if(@income.rebuild == true)
			#need rebuild
			@selltype = Hash.new
	        @costs.each do |cost|
	          key = "#{cost.steeltype_id}_#{cost.format}_#{cost.factory_id}"
	          if @selltype[key].blank?
	            @selltype[key] = Hash.new
	            @selltype[key][:steeltype_id] = cost.steeltype_id
	            @selltype[key][:format] = cost.format
	            @selltype[key][:factory_id] = cost.factory_id
	            @selltype[key][:price] = cost.price
	            @selltype[key][:weight] = cost.weight.to_s.to_f.round(4)
	            @selltype[key][:weight_unit] = cost.weight_unit
	          else
	            @selltype[key][:weight] = cost.weight.to_s.to_f.round(4) +  @selltype[key][:weight].to_s.to_f
	          end
	        end
	        @income.sells.destroy_all
	        @selltype.each do |a,b|
	          sell = Sell.new(b)
	          @income.sells << sell
	        end
	        @income.update_attribute(:rebuild,false)
		end
		@sells = @income.sells
	end

	def create
		
		@sell_weight = params[:sell_weight]
		@sell_price = params[:sell_price]
		@income = @logged_in_user.incomes.find(params[:income])
		@sells = @income.sells
		@sells.each do |f|
			f.update_attribute(:sell_weight,@sell_weight["#{f.id}"])
			f.update_attribute(:sell_price,@sell_price["#{f.id}"])
		end
		redirect_to project_fees_url(:income=>@income.id) and return
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),project_incomes_url]
	end
end