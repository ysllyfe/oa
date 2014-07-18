#encoding:utf-8
class Base::SteeltypesController < Base
	def new
		@steeltype = Steeltype.new
		render 'form',:layout=>'ajax'
	end
	def edit
		@steeltype = Steeltype.find(params[:id])
		render 'form',:layout=>'ajax'
	end
	def create
		@steeltype = Steeltype.new
		@steeltype.name = params[:steeltype][:name]
		@steeltype.save!
		render :text=>'parent.location.reload();' and return
	end
	def update
		@steeltype = Steeltype.find(params[:id])
		@steeltype.update_attribute(:name,params[:steeltype][:name])
		render :text=>'parent.location.reload();' and return
	end
	def destroy
		@steeltype = Steeltype.find(params[:id])
		@steeltype.update_attribute(:softdelete,true)
		_back()
	end
end