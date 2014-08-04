#encoding:utf-8
class Photo < ActiveRecord::Base
	mount_uploader :photo, PhotoUploader
end