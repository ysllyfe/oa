#encoding:utf-8
class Project::IncomesController < Project
	def index
	end

	def new
	end

	def edit
	end

	def create
	end

	def update
	end

	def destroy
	end

	def set_submenu_and_breadcrumbs
		@submenu = t("sidebar.project.my")
		@breadcrumbs << [t("sidebar.project.my"),'#']
	end
end