class IncomeController < ApplicationController
	def index
	end

	def new
		@income = Income.new
	end

	def create
		@income = Income.new(income_param)
		if @income.save
			redirect_to income_path(@income)
		else
			render :new
		end
	end

	def show
		@income = Income.find(params[:id])
	end

	def edit
		@income = Income.find(params[:id])
	end

	def update
		@income = Income.find(params[:id])
		if @income.update(income_param)
			redirect_to income_path(@income)
		else
			render :show
		end
	end

	private
		def income_param
			params.require(:income).permit(:income_date, :description, :increment_interval, :amount)
		end
end
