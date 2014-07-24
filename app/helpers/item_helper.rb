module ItemHelper
	def _item_status(item)
		raw "<i class='fa fa-lock green bigger-130'></i>" if item.ended == 1
	end
	def _remind_payment(item)
		payment = item.payments ? item.payments : 0.0
		return item.price - payment
	end
end