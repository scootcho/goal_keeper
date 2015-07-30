module CategoriesHelper
	# Retur sum of all children transactions 'amount'
	def transaction_count(category)
		number_to_currency(Expense.where(category: category).sum(:amount), precision: 2)
	end
end