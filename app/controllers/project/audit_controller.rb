#encoding:utf-8
class Project::AuditController < Project
	def index
		@incomes = Income.where(submit:1).order('checked asc,id desc').page(params[:page]).per(20)
	end
	def check
		@income = Income.find(params[:income])
		if @income.submit == false
			render :text=>'alert("对不起，这个利润表还在制作中，并未提交。请等待用户提交后再审核。")' and return
		end
		if @income.checked == 1
			@income.update_attribute(:checked,0)
			@income.profit.update_attribute(:checked,0)
		else
			@income.update_attribute(:checked,1)
			@income.profit.update_attribute(:checked,1)
		end
		item = Item.find(@income.item_id)
		item_profit_rebuild(item)
		render :text=>'window.location.reload();' and return
	end


	private
	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.audit")
		@breadcrumbs << [t("sidebar.project.audit"),project_audit_index_url]
	end
	def controller_role
		if @logged_in_user.has_role?('income_check')
		else
			flash[:error] = "你没有对应的权限访问这个页面，对应的用户权限为`income_check`"
			redirect_to deny_url and return
		end
	end
	

end
