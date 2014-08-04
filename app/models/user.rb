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
	before_save :encrypt_password

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
  
	def has_role?(rolename)
		if(rolename.class == String)
			if(rolename.split(' ').first == 'like')
				likename = rolename.split(' ').last
				roles = Role.where('name like "%' + likename + '%"' )
				return self.has_role? roles.collect{|f| f.name}
			end
			return self.roles.find_by_name(rolename) ? true : false
		end
		if(rolename.class == Array)
			t = false
			rolename.each do |f|
				t = self.roles.find_by_name(f) ? true : false
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