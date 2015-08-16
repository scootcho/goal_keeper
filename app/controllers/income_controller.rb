class IncomeController < ApplicationController
	def index
		@income = Income.all
	end

	def new
		@income = Income.new
	end

	def create
		console
		@income = Income.new(income_param)
		if @income.interval == "one-time"
			@income.payment_count = @income.number_of_payments
			@income.save
			redirect_to income_path(@income)
		elsif @income.interval == "weekly"
			payments = @income.number_of_payments.to_i
			@income.payment_count = @income.number_of_payments
			i = 0
			loop do
				i += 1
				@income = Income.new(income_param)
				@income.income_date += i.week
				@income.payment_count = payments - i
				@income.save
				break if i == payments
			end
			redirect_to income_path(@income)
		elsif @income.interval == "bi-weekly"
			payments = @income.number_of_payments.to_i
			i = 0
			loop do
				i += 2
				@income.income_date += i.week
				@income.number_of_payments = @income.number_of_payments.to_i - i
				@income.save
				break if i == payments
			end
			redirect_to income_path(@income)
		elsif @income.interval == "monthly"
			payments = @income.number_of_payments.to_i
			i = 0
			loop do
				i += 4
				@income.income_date += i.week
				@income.number_of_payments = @income.number_of_payments.to_i - i
				@income.save
				break if i == payments
			end
			redirect_to income_path(@income)
		elsif
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
			params.require(:income).permit(:income_date, :description, :number_of_payments, :interval, :amount)
		end
end
