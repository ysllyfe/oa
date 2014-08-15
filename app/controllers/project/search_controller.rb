#encoding:utf-8
class Project::SearchController < Project
	def index
		@items = Item.all.order('ended asc,group_id asc,id desc')
	end

	def search
		@item_id = params[:item_id]
		@btime = params[:btime]
		@etime = params[:etime]
		@conditions = ''
    @conditions << 'SELECT * FROM `income_profits` WHERE `checked`=1 '
    if !@item_id.blank?
      @conditions << ' and item_id=' << @item_id
    end
    if (@btime && @etime)
      @conditions << " and `time` between '#{@btime}' and '#{@etime}' "
    end
    @conditions << ' ORDER BY `item_id` DESC,`time` DESC'
    @profit = Profit.find_by_sql(@conditions)
    if !@item_id.blank?
    	@item = Item.find(@item_id)
    	
    	item_payment_rebuild(@item)
    	@payments = @item.item_payments
    	if @payments
    		@checked_payments = @item.item_payments.where(is_checked:true)
    	end
    	render 'item'
  	else
  		render 'search'
  	end
	end

	def controller_role
		if @logged_in_user.has_role?('like income_search')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like income_search`"
			redirect_to deny_url and return
		end
	end
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.search")
		@breadcrumbs << [t("sidebar.project.search"),project_search_index_url]
	end
end