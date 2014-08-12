#encoding:utf-8
class Staffs::AjaxController < Staffbox
	skip_before_filter :set_submenu_and_breadcrumbs
	skip_before_filter :controller_role
	layout 'ajax'
	before_filter :check,:only=>[:base_delete,:base_audit,:info_delete,:info_audit,:departments_delete,:departments_audit,:edu_delete,:edu_audit,:member_delete,:member_audit,:contact_delete,:contact_audit]
	def search
		@user = User.find_by(username:params[:username])
		redirect_to staffs_basis_url(@user.id)
	end
	#基础信息管理
	def base
		@user = User.find(params[:id])
		@base = @user.baseinfo
	end
	def base_create
		s = params.require(:staff).permit(:sex, :card, :birth, :ethnic, :political)
		@user = User.find(params[:id])
		@base = @user.baseinfo
		@base.update_attributes(s)
		render :text=>'parent.location.reload();' and return
	end
	def base_delete
	end
	#个人信息管理
	def info
		@user = User.find(params[:id])
		@info = @user.infos.last || Info.new
	end
	def info_create
		@user = User.find(params[:id])
		#"birthday"=>"阳历", "birth"=>"07-02", "lunar"=>"", "labor"=>"false", "lab_start"=>"", "lab_end"=>"", "security"=>"false", "sec_start"=>"", "sec_end"=>""
		#info"=>{"marriage"=>"1", "phone"=>"13802516307", "tel"=>"13802516307", "address"=>"骏景花园", "entry_at"=>"2003-07-07", "positive_at"=>"2003-07-07", "departure_at"=>"", "security"=>"1"}
		s = params.require(:info).permit(:marriage,:phone,:tel,:address,:entry_at,:positive_at,:departure_at,:security)
		#未审核的删除
		@user.infos.where(ischecked: false).delete_all
		info = Info.new(s)
		#info.birthday = params[:birthday]
		info.birth = params[:birth]
		info.lunar = params[:lunar]
		info.labor = params[:labor]
		info.lab_start = params[:lab_start]
		info.lab_end = params[:lab_end]
		info.sec_start = params[:sec_start]
		info.sec_end = params[:sec_end]
		info.security = params[:security]
		@user.infos << info
		render :text=>'parent.location.reload();' and return
	end
	def info_delete
		info = Info.find(params[:id])
		info.delete
		render :text=>'parent.location.reload();' and return
	end
	def info_audit
		info = Info.find(params[:id])
		@user = User.find(info.user_id)
		@user.infos.where(ischecked:true).delete_all
		info.update_attribute(:ischecked,true)
		render :text=>'parent.location.reload();' and return
	end
	#部门信息
	def departments
		@user = User.find(params[:id])
		@depart = @user.departments.last || Department.new
		@groups = Group.where(system:true).order('id asc')
	end
	def departments_create
		#"department"=>{"group_name"=>"龙杰云南公司", "department"=>"总裁办", "post"=>"总裁", "level"=>"A2", "start_at"=>"2013-05-29", "end_at"=>"", "info"=>""}
		@user = User.find(params[:id])
		@user.departments.where(ischecked: false).delete_all
		s = params.require(:department).permit(:group_name,:department,:post,:level,:start_at,:end_at,:info)
		group = Group.find_by(name:params[:department][:group_name])
		depart = Department.new(s)
		depart.group_id = group.id
		@user.departments << depart
		render :text=>'parent.location.reload();' and return
	end
	def departments_delete
		con = Department.find(params[:id])
		con.delete
		render :text=>'parent.location.reload();' and return
	end
	def departments_audit
		depart = Department.find(params[:id])
		depart.update_attribute(:ischecked,true)
		render :text=>'parent.location.reload();' and return
	end

	def edu
		@user = User.find(params[:id])
		@edu = @user.educations.last || Education.new
	end
	def edu_create
		@user = User.find(params[:id])
		#"education"=>{"school"=>"南京航空航天大学", "specialty"=>"工商管理", "degree"=>"本科", "start_at"=>"2003-09-01", "end_at"=>"2007-07-31", "info"=>""}
		@user.educations.where(ischecked: false).delete_all
		s = params.require(:education).permit(:school,:specialty,:degree,:start_at,:end_at,:info)
		edu = Education.new(s)
		@user.educations << edu
		render :text=>'parent.location.reload();' and return
	end
	def edu_delete
		con = Education.find(params[:id])
		con.delete
		render :text=>'parent.location.reload();' and return
	end
	def edu_audit
		edu = Education.find(params[:id])
		edu.update_attribute(:ischecked,true)
		render :text=>'parent.location.reload();' and return
	end

	def member
		@user = User.find(params[:id])
		@member = @user.families.last || Family.new
	end

	def member_create
		@user = User.find(params[:id])
		@user.families.where(ischecked: false).delete_all
		# "family"=>{"relationship"=>"父子", "name"=>"杨学思", "phone"=>"13802516307", "workunits"=>"龙杰贸易", "address"=>"骏景花园"}
		s = params.require(:family).permit(:relationship,:name,:phone,:workunits,:address)
		family = Family.new(s)
		@user.families << family
		render :text=>'parent.location.reload();' and return
	end

	def member_delete
		con = Family.find(params[:id])
		con.delete
		render :text=>'parent.location.reload();' and return
	end
	def member_audit
		fa = Family.find(params[:id])
		fa.update_attribute(:ischecked,true)
		render :text=>'parent.location.reload();' and return
	end

	def contact
		@user = User.find(params[:id])
		@contact = @user.contacts.last || Contact.new
	end
	def contact_create
		@user = User.find(params[:id])
		@user.contacts.where(ischecked: false).delete_all
		s = params.require(:contact).permit(:relationship,:name,:phone,:address)
		contact = Contact.new(s)
		@user.contacts << contact
		render :text=>'parent.location.reload();' and return
	end
	def contact_delete
		con = Contact.find(params[:id])
		con.delete
		render :text=>'parent.location.reload();' and return
	end
	def contact_audit
		con = Contact.find(params[:id])
		con.update_attribute(:ischecked,true)
		render :text=>'parent.location.reload();' and return
	end
	def check
		if !@logged_in_user.has_role?('staff_check')
			render :text=>'alert("对不起，你没有对应的操作权限，对应的权限为 `staff_check`")' and return
		end
	end
end