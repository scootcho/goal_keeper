class ExpensesController < ApplicationController
	def stats
		@expenses = Expense.all
	end

	def index
	end

	def new
		@expense = Expense.new
		@category = Category.new
	end

	def create
		@expense = Expense.new(expense_param)
		@category = Category.new(category_param)
		if @expense.save & @category.save
			redirect_to :stats
		else
			render :new
		end
	end

	private
		def expense_param
			params.require(:expense).permit(:transaction_date, :description, :amount, :category_id)
		end

		def category_param
			params.require(:category).permit(:name)
		end
end
