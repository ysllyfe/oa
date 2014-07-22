#encoding:utf-8
class Project < Admin
	include IncomeBase
	before_filter :set_item_color
	before_filter :set_steps
	before_filter :set_submenu_and_breadcrumbs
	def set_item_color
		@item_colors = %W(item-orange item-orange2 item-red item-red2  item-green item-green2 item-blue item-blue2 item-blue3 item-pink item-purple item-black item-grey item-brown item-default)
	end
	def set_steps
		@steps = Array.new
		#info url step
		@steps << ['基本信息',edit_project_income_url("_replays_"),1]
		@steps << ['车辆信息',project_trucks_url(:income=>"_replays_"),2]
		@steps << ['销售信息',project_costs_url(:income=>"_replays_"),3]
		@steps << ['费用情况',project_fees_url(:income=>"_replays_"),4]
		@steps << ['原始磅单',original_project_income_url("_replays_"),5]
	end
	def set_controller_sidebar
		@sidebar = t("sidebar.menu.project")
		@breadcrumbs << [t("sidebar.menu.project"),'#']
	end
end