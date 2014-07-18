#encoding:utf-8
class Base::FeesController < Base
	def new
		@fee = IncomeFeeType.new
		@url = base_fees_url
		render 'form',:layout=>'ajax'
	end
	def edit
		@fee = IncomeFeeType.find(params[:id])
		@url = base_fee_url(@fee)
		render 'form',:layout=>'ajax'
	end
	def create
		@fee = IncomeFeeType.new
		@fee.name = params[:income_fee_type][:name]
		@fee.save!
		render :text=>'parent.location.reload();' and return
	end
	def update
		@fee = IncomeFeeType.find(params[:id])
		@fee.update_attribute(:name,params[:income_fee_type][:name])
		render :text=>'parent.location.reload();' and return
	end
	def destroy
		@fee = IncomeFeeType.find(params[:id])
		@fee.update_attribute(:softdelete,true)
		_back()
	end
end