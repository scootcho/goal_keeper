class GoalsController < ApplicationController
	def index
		@goals = Goal.due_soonest
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
		@goal = Goal.find(params[:id])
		if @goal.destroy
			redirect_to goals_path
		else
			render :show
		end
	end

	private
		def goal_param
			params.require(:goal).permit(:title, :amount, :due_date)
		end
end
