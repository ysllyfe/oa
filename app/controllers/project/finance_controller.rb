#encoding:utf-8
class Project::FinanceController < Project
	def index
		@items = Item.all.order('ended asc,group_id asc,id desc')
	end
	def ended
		if @logged_in_user.has_role?('income_finance_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`income_finance_check`"
			redirect_to deny_url and return
		end
		@item = Item.find(params[:item_id])
    @payment = ItemPayment.where(item_id:@item.id,is_checked:false).first
    if @payment
      render :text => 'render_error("对不起，存在未审核款项，请全部审核完后再进行结款操作。");' and return
    else
      @item.update_attribute('ended',1)
      item_payment_rebuild(@item)
    end
    render :text=>'window.location.reload();' and return
	end
	def search
		@view = params[:view] ? params[:view] : 'default'
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
	def new
		#add item_payment
		if !@logged_in_user.has_role?('like income_finance')
			render :text=>'render_error("你没有对应的权限访问这个页面，对应的用户权限为`like 你没有对应的权限访问这个页面，对应的用户权限为`like income_query``")' and return
		end
		@item = Item.find(params[:item_id])
		@payment = ItemPayment.new
		render :layout=>'ajax'
	end
	def create
		# "item_payment"=>{"pay_time"=>"", "ptype"=>"1", "money"=>"", "info"=>""}
		s = params.require(:item_payment).permit(:pay_time,:ptype,:money,:info)
		@payment = ItemPayment.new(s)
		@payment.user_id = @logged_in_user.id
		@item = Item.find(params[:item_id])
		@item.item_payments << @payment

		#<%=@view == 'payments' ? '' : 'active'%>
		add_notification(@logged_in_user.username,'income_finance_check',"/project/finance/search?item_id=#{@item.id}&view=payments","提交了工程收款信息")
		render :text=>'parent.window.location.reload();'
	end
	def check
		if @logged_in_user.has_role?('income_finance_check')
		else
			render :text=>"render_error('你没有对应的权限访问这个页面，对应的用户权限为`income_finance_check`')" and return
		end
		@payment = ItemPayment.find(params[:id])
		@item = Item.find(@payment.item_id)
		if @item.ended == 1
			render :text=>'render_error("项目已结款。无法操作。")' and return
		end
		@payment.update_attribute('is_checked',true)
		item_payment_rebuild(@item)
		render :text=>"window.location.reload();"
	end
	def destroy
		if @logged_in_user.has_role?('like income_finance')
		else
			render :text=>"render_error('你没有对应的权限访问这个页面，对应的用户权限为`like income_finance`')" and return
			redirect_to deny_url and return
		end
		@payment = ItemPayment.find(params[:id])
		@item = Item.find(@payment.item_id)
		if @item.ended == 1
			render :text=>'render_error("项目已结款。无法操作。")' and return
		end
		@payment.delete
		item_payment_rebuild(@item)
		render :text=>'window.location.reload();'
	end
	def controller_role
		if @logged_in_user.has_role?(['like income_query','like income_finance'])
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`like income_query`或`like income_finance`"
			redirect_to deny_url and return
		end
	end
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.finance")
		@breadcrumbs << [t("sidebar.project.finance"),'#']
	end
end