#encoding:utf-8
class PayslipsController < Admin
	require 'csv'
	before_filter :admin,:except=>[:my]

	def index
		@submenu = t("sidebar.payslip.adm")
		@payslips = Payslip.order('id desc').page(params[:page]).per(10)
	end

	def my
		@submenu = t("sidebar.payslip.my")
		@payslips = Payslip.where(checked:true).order('id desc').page(params[:page]).per(10)
		if(params[:id])
			@payslip = Payslip.find(params[:id])
			@details = @payslip.payslip_details.find_by(user_id:@logged_in_user.id)
			if @details.blank?
				render :text=>'对不起，没有对应的工资单。' and return
			end
			render 'details',:layout=>false and return
		end
	end

	def new
		@submenu = t("sidebar.payslip.adm")
		@payslip = Payslip.new
	end
	def submit
		@utfpath = params[:utfpath]
		@time = params[:time]
		@payslip = Payslip.new()
		@payslip.time = @time
		@payslip.user_id = @logged_in_user.id
		if @payslip.save
			CSV.foreach(@utfpath) do |col|
				if @user = User.find_by_username(col[1].strip)
					user_id = @user.id
					username = @user.username
				else
					user_id = 0
					username = col[1].strip
				end
				@item = PayslipDetail.new
				@item[:payslip_id] = @payslip.id
				@item[:user_id] = user_id
				@item[:username] = username
				@item[:post] = col[2] ? col[2].strip : nil
				@item[:entry_time] = col[3] ? col[3].strip : nil
				@item[:probation_wage] = col[4] ? col[4].gsub(/,/,'').to_f : nil
				@item[:wage] = col[5] ? col[5].gsub(/,/,'').to_f : nil
				@item[:post_wage] = col[6] ? col[6].gsub(/,/,'').to_f : nil
				@item[:performance_wage] = col[7] ? col[7].gsub(/,/,'').to_f : nil
				@item[:attendance] = col[8] ? col[8].gsub(/,/,'').to_f : nil
				@item[:job_subsidies] = col[9] ? col[9].gsub(/,/,'').to_f : nil
				@item[:spe_subsidies] = col[10] ? col[10].gsub(/,/,'').to_f : nil
				@item[:other_subsidies] = col[11] ? col[11].gsub(/,/,'').to_f : nil
				@item[:leave_plus] = col[12] ? col[12].gsub(/,/,'').to_f : nil
				@item[:late_plus] = col[13] ? col[13].gsub(/,/,'').to_f : nil
				@item[:ltd_plus] = col[14] ? col[14].gsub(/,/,'').to_f : nil
				@item[:sb_plus] = col[15] ? col[15].gsub(/,/,'').to_f : nil
				@item[:other_plus] = col[16] ? col[16].gsub(/,/,'').to_f : nil
				@item[:wage_total] = col[17] ? col[17].gsub(/,/,'').to_f : nil
				@item[:fax] = col[18] ? col[18].gsub(/,/,'').to_f : nil
				@item[:wage_real] =  col[19] ? col[19].gsub(/,/,'').to_f : nil
				@item[:cash_wage] = col[20] ? col[20].gsub(/,/,'').to_f : nil
				@item[:info] = col[21] ? col[21].strip : nil
				@item.save
			end
		end

		add_notification(@logged_in_user.username,'payslips_check',payslips_url,"提交了新工资单")
		redirect_to payslips_url and return
	end

	def create
		path = params[:file].tempfile
		@time = params[:time]
		@utfpath = File.path(path) + 'utf-8'
		lines = Array.new
		File.open(path, "r") do |file|  
	        file.each_line do |line,index|  
	            lines << line.encode('UTF-8','GB2312')
	        end  
	    end
	    File.open(@utfpath,"a+") do |file|
	    	lines.each do |f|
	    		file << f
	    	end
	    end
	    @lines = Array.new
	    CSV.foreach(@utfpath) do |col|
	    	@lines << col
		end
		File.unlink(File.path(path))
	end

	def show
		@payslip = Payslip.find(params[:id])
		@lines = @payslip.payslip_details
	end

	def check
		if !@logged_in_user.has_role?('payslips_check')
			render :text=>'render_error("对不起，您没有对应的权限，对应的权限为`payslips_check`。");' and return
		end
		@payslip = Payslip.find params[:id]
		if @payslip.checked == true
			@payslip.update_attribute(:checked,false)
		else
			group = Group.where(system:1).collect{|x| x.id}
			msg = @payslip.name + '已上传至OA'
			url = my_payslips_url
			send_sms_notification_by_group(group,msg,url)
			@payslip.update_attribute(:checked,true)
		end
		render :text=>'window.location.reload();' and return
	end
	def destroy
		@payslip = Payslip.find params[:id]
		if @payslip.checked == true
			if !@logged_in_user.has_role?('payslips_check')
				render :text=>'render_error("对不起，表单已审核通过。您没有对应的权限，对应的权限为`payslips_check`。");' and return
			end
		end
		@payslip.destroy
		render :text=>'window.location.reload();' and return
	end
	def admin
		if !@logged_in_user.has_role?('like payslips_')
			redirect_to my_payslips_url and return
		end
	end
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.payslip")
		@breadcrumbs << [t("sidebar.menu.payslip"),payslips_url]
	end
	def controller_role
	end
end