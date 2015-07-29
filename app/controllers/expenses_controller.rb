class ExpensesController < ApplicationController
	def stats
	end

	def index
	end

	def new
		@expense = Expense.new
	end

	private
		def expense_param
			params.require(:expense).permit(:transaction_date, :description, :amount)
		end
end
