#encoding:utf-8
class Image < ActiveRecord::Base
	#文章图片
	mount_uploader :avatar, AvatarUploader
end