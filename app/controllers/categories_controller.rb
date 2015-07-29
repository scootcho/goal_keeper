class CategoriesController < ApplicationController
	def create
		@category = Category.new(category_param)
	end

	private
		def category_param
			params.require(:categories).permit(:name)
		end

end
