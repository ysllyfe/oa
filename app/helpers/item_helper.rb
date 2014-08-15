module ItemHelper
	def _payments_operate(payment)
		html = []
		if payment.is_checked == 1 || payment.is_checked == true
			html << '<span class="label label-success arrowed">已审核</span>'
		else
			html << '<a href="'+check_project_finance_url(payment.id)+'" class="label label-danger arrowed"  data-remote="true" data-method="put" data-confirm="确认审核？" rel="nofollow">审核</a>'
		end
		html << ' <a href="'+project_finance_url(payment.id)+'" class="btn btn-warning btn-xs" data-remote="true" data-method="delete" data-confirm="确认删除？" rel="nofollow"><i class="ace-icon fa fa-trash-o  bigger-110 icon-only"></i></a>'
		raw html.join('')
	end
	def _tip_item(item,url='')
		if url
			name = '<a href="'+url+'">'+item.name+'</a>'
		else
			name = item.name
		end
		raw '<span title="" data-placement="right" data-rel="tooltip" class="tooltip-success" data-original-title="'+item.profitrate_yun.to_s+'元 / '+item.profitrate_percent.to_s+'%">'+name+'</span>'
	end
	def _item_status(item)
		raw "<i class='fa fa-lock green bigger-130'></i>" if item.ended == 1
	end
	def _remind_payment(item)
		payment = item.payments ? item.payments : 0.0
		return item.price - payment
	end
end