#encoding:utf-8
class Base::ItemsController < Base
	def index
		@items = Item.where(softdelete:false).order('ended asc,group_id asc,id desc')
		@factories = Factory.where(softdelete:false).order('id desc')
		@steeltypes = Steeltype.where(softdelete:false).order('id desc')
		@fees = FeeType.where(softdelete:false).order('id desc')
		
	end
	def new
		@item = Item.new
		@groups = Group.where(system:1)
		render 'form',:layout=>'ajax'
	end
	def create
		@item = Item.new
		@item.name = params[:item][:name]
		@item.group_id = params[:item][:group_id]
		@item.rate = 0
		@item.save!
		render :text=>'parent.location.reload();' and return
	end
	def edit
		@item = Item.find(params[:id])
		@groups = Group.where(system:1)
		render 'form',:layout=>'ajax'
	end
	def update
		@item = Item.find(params[:id])
		@item.update_attribute(:name,params[:item][:name])
		@item.update_attribute(:group_id,params[:item][:group_id])
		render :text=>'parent.location.reload();' and return
	end
	def destroy
		@item = Item.find(params[:id])
		@item.update_attribute(:softdelete,true)
		_back()
	end
end