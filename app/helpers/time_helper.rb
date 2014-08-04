#encoding:utf-8
module TimeHelper
	def _time_plus(time)
		second = Time.now - time
		if second < 60
			'刚刚'
		elsif second < 3600
			(second/60).round.to_s + "分钟前"
		elsif second < 3600*24
			(second/3600).round.to_s + "小时前"
		elsif second < 3600*24*7
			(second/(3600*24)).round.to_s + "天前"
		else
			time.to_s(:m)
		end
	end
end