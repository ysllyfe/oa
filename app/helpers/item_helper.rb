module ItemHelper
	def _item_status(item)
		raw "<i class='fa fa-flag red bigger-130'></i>" if item.ended == 1
	end
end