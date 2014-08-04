#encoding:utf-8
class UeditorController < Admin
	def showimage
		@dialogs_url = '/ueditor_rails/dialogs/'
		@images_url = @dialogs_url + 'image/'
		@testrand = Time.now
		render 'image',:layout=>false
	end
	def imageUp
		@image = Image.new()
		@image.avatar = params[:upfile]
		if @image.save
			msg = {:url=>@image.avatar.url,:title=>params[:pictitle],:original=>params[:fileName],:state=>'SUCCESS'}
		else
			msg = {:url=>'',:title=>'',:original=>'',:state=>'文件保存时出错'}
		end
		render :json=>msg.to_json
	end
	def imageManager
		page = params[:page] ? params[:page].to_i : 1
		@images = Image.find(:all,:order=>'id desc',:limit=>20,:offset=>(page-1)*20)
		msg = @images.collect{|x| x.avatar.url + '|' + x.avatar.url(:s)}.join("ue_separate_ue")
		render :text=>msg
	end

	def set_controller_sidebar
	end
end