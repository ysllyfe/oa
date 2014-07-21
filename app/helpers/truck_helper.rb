module TruckHelper
	def _original_sum(truck)
		#运货重量：41.0吨　|　运费　 单价75.0 * 41.0吨　＝　3075.0元 
		html = "运货重量：#{truck.weight}吨　|　运费　"
		if truck.chartered == true
			html += "包车 #{truck.cost}元"
		else
			html += "单价#{truck.price} * #{truck.weight}吨 = #{truck.cost}元"
		end
		return html
	end
end