class GoalsController < ApplicationController
	def index
		@goals = Goal.order_by_due_earliest
	end

	def show
		@goal = Goal.find(params[:id])
	end

	def new
		@goal = Goal.new
	end

	def edit
		@goal = Goal.find(params[:id])
	end

	def create
		@goal = Goal.new(goal_param)
		if @goal.save
			redirect_to goal_path(@goal)
		else
			render :new
		end
	end

	def update
		@goal = Goal.find(params[:id])
		if @goal.update(goal_param)
			redirect_to goal_path(@goal)
		else
			render :edit
		end
	end

	def destroy
		@status = "FAIL"
		@goal = Goal.find(params[:id])
		if @goal.destroy
			@status = "SUCCESS"
			respond_to :js
		else
			redirecto_to :show
		end
	end

	def current_month
		time_now = Time.now
		@year = time_now.year
		@month = time_now.month
		@beginning_of_month = Date.civil(@year, @month, 1)
  	@end_of_month = Date.civil(@year, @month, -1)
	end

	def prev_month
		@month = params[:month].to_i
		@year = params[:year].to_i
		if @month == 1
			@year -=1
			@month = 12
		else
			@month -= 1
		end
		@beginning_of_month = Date.civil(@year, @month, 1)
  	@end_of_month = Date.civil(@year, @month, -1)
  	respond_to :js
	end

	def next_month
		@month = params[:month].to_i
		@year = params[:year].to_i
		if @month == 12
			@year += 1
			@month = 1
		else
			@month += 1
		end
		@beginning_of_month = Date.civil(@year, @month, 1)
  	@end_of_month = Date.civil(@year, @month, -1)
  	respond_to :js
	end

	def home
		@goal = Goal.current_goal(Date.today)
		@today = Date.today
		@wkbeg = @today.at_beginning_of_week - 1
		@wkend = @today.at_end_of_week - 1
	end

	def next_week
		@wkbeg = Date.parse(params[:wkbeg]) + 7.days
		@wkend = Date.parse(params[:wkend]) + 7.days
  	respond_to :js
	end

	def prev_week
		@wkbeg = Date.parse(params[:wkbeg]) - 7.days
		@wkend = Date.parse(params[:wkend]) - 7.days
  	respond_to :js
	end

	private
		def goal_param
			params.require(:goal).permit(:title, :amount, :due_date, :filepicker_url)
		end
end
