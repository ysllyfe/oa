#encoding:utf-8
class Base::FactoriesController < Base
	def new
		@factory = Factory.new
		render 'form',:layout=>'ajax'
	end
	def edit
		@factory = Factory.find(params[:id])
		render 'form',:layout=>'ajax'
	end
	def create
		@factory = Factory.new
		@factory.name = params[:factory][:name]
		@factory.save!
		render :text=>'parent.location.reload();' and return
	end
	def update
		@factory = Factory.find(params[:id])
		@factory.update_attribute(:name,params[:factory][:name])
		render :text=>'parent.location.reload();' and return
	end
	def destroy
		@factory = Factory.find(params[:id])
		@factory.update_attribute(:softdelete,true)
		_back()
	end
end