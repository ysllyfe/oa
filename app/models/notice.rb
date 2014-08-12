#encoding:utf-8
class Notice < ActiveRecord::Base

	attr_accessor :group_id
	has_and_belongs_to_many :groups

	def views
		NoticeView.where(notice_id:self.id).order('id desc')
	end
	def views=(user)
		u = NoticeView.where(user_id:user.id,notice_id:self.id).first
		if u
		else
			n = NoticeView.new
			n.user_id = user.id
			n.notice_id = self.id
			n.save!
		end
	end

	def username
		user = User.find(self.user_id)
		if user
			user.username
		else
			''
		end
	end
	def group_name
		self.groups.collect{|g| g.name}.join(" ") if self.groups
	end
	def set_group(group_id)
		self.groups.delete_all
		group_id.each do |g|
			if !g.blank?
				group = Group.find(g)
				self.groups << group
			end
		end
	end
end