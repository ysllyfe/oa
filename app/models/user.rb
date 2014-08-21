#encoding:utf-8
class User < ActiveRecord::Base
	attr_accessor :password
	validates_presence_of :username
	validates_presence_of :password, :if=>:password_required?
	validates_presence_of :password_confirmation, :if=>:password_required?

	validates_confirmation_of :password, :if=>:password_required?

	validates_length_of :username, :within => 2..64, :message => '对不起，名称在2个字符以上'
	validates_length_of :password, :within => 6..20, :if => :password_required?

	#avatar是社區化的頭像，個人可以修改
	mount_uploader :avatar, AvatarUploader
	#photos是公司給個人的頭像，個人無法修改
	mount_uploader :photos, AvatarUploader
	
	has_many :incomes
	has_many :infos,dependent: :destroy
	has_one :staff,dependent: :destroy
	has_many :departments,dependent: :destroy
	has_many :educations,dependent: :destroy
	has_many :families,dependent: :destroy
	has_many :contacts,dependent: :destroy
	has_and_belongs_to_many :rolegroups,:association_foreign_key=>'rolepart_id'
	has_and_belongs_to_many :roles
	has_and_belongs_to_many :smsgroups
	before_save :encrypt_password
	belongs_to :group

	def method_missing(method,*args)
		method_name = method.to_s
    super(method, *args)
	rescue NoMethodError
		if method_name =~ /=$/
			var_name = method_name.gsub('=', '')
			if(var_name.index("config_") === 0)
				#以config_开头的，说明是config
				#是我们要的，进行操作
				name = var_name.gsub("config_", '')
				if(name.to_s == 'auto')
					string = args.first
					name = string[0]
					value = string[1]
				else
					value = args.first.to_s
				end
				
				if item = Setting.find_by(user_id:self.id,name:name)
	        item.update_attribute(:value, value)
	      else
	        Setting.create(name: name, value: value, user_id: self.id)
	      end
			end
		else
			if(method_name.index("config_") === 0)
				name = method_name.gsub("config_", '')
				if(name == 'global')
					string = args.first
					name = string[0]
				end
				s = Setting.find_by(name: name,user_id: self.id)
				if s
					s.value
				else
					nil
				end
			end
		end
  end 


	def attachments
		Photo.where(user_id: self.id).order('id asc')
	end

	def department
		self.departments.where(ischecked:true).order('id desc').first || Department.new
	end

	def info
		self.infos.where(ischecked:true).order('id desc').first || Info.new
	end
	
	def baseinfo
		self.staff || Staff.new
	end

	def password_required?
		self.hashed_password.blank? || !self.password.blank?
	end
  
	def self.authenticate(username,password)
		user = where(username:username).first
		if user.blank?
			return {:code=>404,:user=>nil}
		end
		if user.hashed_password != User.encrypt(password)
			return {:code=>400,:user=>nil}
		end
		if user.enabled == false
			return {:code=>500,:user=>nil}
		end
		return {:code=>200,:user=>user}
	end
  
	def self.encrypt(string)
		return Digest::SHA256.hexdigest(string)
	end
  
  def reloadroles
  	self.roles.delete_all
  	groups = self.rolegroups
  	groups.each do |t|
  		if t.roles
  			t.roles.each do |role|
  				self.roles << role
  			end
  		end
  	end
  end

	def has_role?(rolename)
		if self.roles.find_by(name: 'administrator')
			#超级管理员，直接返回真
			return true
		end
		if(rolename.class == String)
			# like income_query
			if(rolename.split(' ').first == 'like')
				likename = rolename.split(' ').last
				roles = Role.where('name like "%' + likename + '%"' )
				return self.has_role? roles.collect{|f| f.name}
			end
			return self.roles.find_by(name: rolename) ? true : false
		end
		if(rolename.class == Array)
			t = false
			rolename.each do |f|
				t = self.has_role?(f)
				if(t == true)
					return true
				end
			end
		end
		return false
	end

	private
	def encrypt_password
		self.hashed_password = User.encrypt(self.password) if !self.password.blank?
	end
end