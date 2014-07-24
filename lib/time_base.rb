# encoding: utf-8
module TimeBase
	protected
	
	def _time_std(time)
		date = Time.at(time) if time.class == Time
		date = DateTime.parse(time) if time.class == String
		return date
	end

	def _daybegin(time)
		date = _time_std time
		Time.mktime(date.year,date.month,date.day,0,0,0)
	end

	def _dayend(time)
		date = _time_std time
		Time.mktime(date.year,date.month,date.day,11,59,59)
	end

	def _month(time)
		_month_first(time) + '/' + _month_last(time)
	end

	def _month_pre(time)
		date = _time_std time
		year = date.year
		month = date.month
		if month == 1
			month = 12
			year -= 1
		else
			month -= 1
		end
		Date.new(year,month,1).strftime("%Y-%m-%d")
	end

	def _month_next(time)
		date = _time_std time
		year = date.year
		month = date.month
		if month == 12
			month = 1
			year += 1
		else
			month += 1
		end
		Date.new(year,month,1).strftime("%Y-%m-%d")
	end

	def _month_first(time)
		date = _time_std time
		Date.new(date.year,date.month,1).strftime("%Y-%m-%d")
	end

	def _month_last(time)
		date = _time_std time
		Date.new(date.year, date.month, -1).strftime("%Y-%m-%d")
	end

	def _unix2date(unixtime)
		#unix时间戳转为DATETIME型
		#例如'1388246400'转为'2013-12-29 00:00:00 +0800'
		Time.at unixtime.to_i
	end

	def _date2unix(date)
		#unix时间戳转为DATETIME型
		#例如'2013-12-29 00:00:00 +0800'转为'1388246400'

	end

	def _js2datetime(jstime)
		#js时间转为datetime型
		#例如'Mon Jan 06 2014 09:00:00 GMT 0800 (CST)'转为
		DateTime.parse(jstime).strftime('%Y-%m-%d %H:%M:%S').to_s
	end

end