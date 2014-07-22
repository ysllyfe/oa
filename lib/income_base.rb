# encoding: utf-8
module IncomeBase
	def _round(f,num=4)
		return f.to_s.to_f.round(num)
	end
	def item_income_count(item)
		#调出所有的利润表
		profits = item.profits.where(checked: true)
		weight = profits.inject(0.0){|mem,var| mem + _round(var.weight)}
		iweight = profits.inject(0.0){|mem,var| mem + _round(var.iweight)}
		price = profits.inject(0.0){|mem,var| mem + _round(var.price)}
		profit = profits.inject(0.0){|mem,var| mem + _round(var.profits)}
		profitrate_yun = _round(profit / weight)
		profitrate_percent = _round(profit / price) * 100
		item.update_attributes({:weight=>weight,:iweight=>iweight,:price=>price,:profit=>profit,:profitrate_percent=>profitrate_percent,:profitrate_yun=>profitrate_yun})
	end
	def cb_count(income)
		#成本计算
		trucks = income.trucks
		sells = income.sells
		fees = income.fees

		#费用冲抵
		fee_sells = income.fee_sells

		#成本
		_cb = 0.0
		#调货成本
		_dcb = 0.0
		#运费成本
		_ycb = 0.0
		#其它成本
		_qcb = 0.0
		#销售
		_sell = 0.0
		_basesell = 0.0
		#费用冲抵
		_fee_sells = 0.0
		#利润
		_lr = 0.0 
		#原始磅重
		_yweight = 0.0
		#销售重量
		_weight = 0.0


		_ycb = trucks.inject(0.0) do |mem, var|
			if var.chartered == true
				mem + _round(var.cost)
			else
				mem + _round(var.cost.to_f * var.price.to_f) 
			end
		end
		_qcb = fees.inject(0.0){|mem,var| mem + _round(var.cost)}

		_weight = sells.inject(0.0) { |mem, var|  mem + _round(var.sell_weight.to_f)}

		_basesell = sells.inject(0.0) { |mem,var| mem + _round(var.sell_weight.to_f * var.sell_price.to_f)}

		_fee_sells = fee_sells.inject(0.0) { |mem,var| mem + _round(var.cost.to_f) }

		trucks.each do |truck|
			costs = truck.costs
			weight = costs.inject(0.0){|sum,n| sum + _round(n.weight)}
			dcb = costs.inject(0.0){|sum,n| sum + _round(n.weight.to_s.to_f * n.price.to_s.to_f)}
			#原始磅单
			_dcb += dcb
			_yweight += weight
		end
		#公式：
		#调货成本 + 运费 + 其它费用 = 成本
		#销售情况 + 费用冲抵 = 销售共计
		#销售 - 成本 = 利润
		_sell = _basesell + _fee_sells
		_cb = _dcb + _ycb + _qcb
		_lr = _sell - _cb
		return {:yweight=>_yweight,:cb => _cb,:dcb=>_dcb,:ycb=>_ycb,:qcb=>_qcb,:weight=>_weight,:basesell=>_basesell,:fee_sells=>_fee_sells,:sell=>_sell,:lr=>_lr}
	end


end