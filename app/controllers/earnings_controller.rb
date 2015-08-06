class EarningsController < ApplicationController
	def index
		@earnings = Earning.earnings
	end

	def new
		@earning = Earning.new
	end

	def create #TODO: Refactor this. Extract this to a helper
		@earning = Earning.new(earning_param)
		if @earning.interval == "one-time"
			@earning.payment_count = @earning.number_of_payments
			@earning.save
			redirect_to earning_path(@earning)
		elsif @earning.interval == "weekly"
			payments = @earning.number_of_payments.to_i
			i = 0
			loop do
				i += 1
				@earning = Earning.new(earning_param)
				@earning.earning_date += i.week
				@earning.payment_count = i
				@earning.save
				break if i == payments
			end
			redirect_to earning_path(@earning)
		elsif @earning.interval == "bi-weekly"
			payments = @earning.number_of_payments.to_i
			i = 0
			loop do
				i += 1
				num_week = i * 2
				@earning = Earning.new(earning_param)
				@earning.earning_date += num_week.week
				@earning.payment_count = i
				@earning.save
				break if i == payments
			end
			redirect_to earning_path(@earning)
		elsif @earning.interval == "monthly"
			payments = @earning.number_of_payments.to_i
			i = 0
			loop do
				i += 1
				num_week = i * 4
				@earning = Earning.new(earning_param)
				@earning.earning_date += num_week.week
				@earning.payment_count = i
				@earning.save
				break if i == payments
			end
			redirect_to earning_path(@earning)
		elsif
			render :new
		end
	end

	def show
		@earning = Earning.find(params[:id])
	end

	def edit
		@earning = Earning.find(params[:id])
	end

	def update
		@earning = Earning.find(params[:id])
		if @earning.update(earning_param)
			redirect_to earning_path(@earning)
		else
			render :show
		end
	end

	private
		def earning_param
			params.require(:earning).permit(:earning_date, :description, :number_of_payments, :payment_count, :interval, :amount)
		end
end
