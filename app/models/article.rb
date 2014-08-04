#encoding:utf-8
class Article < ActiveRecord::Base
	attr_accessor :group_id
	
	has_one :article_content
	has_and_belongs_to_many :groups
	before_create :set_hash_id


	def views
		ArticleView.where(article_id:self.id).order('id desc')
	end
	def views=(user)
		u = ArticleView.where(user_id:user.id,article_id:self.id).first
		if u
		else
			n = ArticleView.new
			n.user_id = user.id
			n.article_id = self.id
			n.save!
		end
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

	def content
		c = ArticleContent.where(hash_id: self.hash_id).first
		return c.info if !c.blank?
		return ArticleContent.new().info
	end
	def content=(content)
		c = ArticleContent.where(hash_id: self.hash_id).first
		if !c.blank?
			c.update_attribute(:info,content)
		else
			c = ArticleContent.new()
			c.hash_id = self.hash_id
			c.info = content
			c.save!
		end
	end
	private
	def set_hash_id
		self.hash_id = SecureRandom.hex(8)
	end
end