class PagesController < ApplicationController
	def home
		@goal = Goal.last
	end
end
