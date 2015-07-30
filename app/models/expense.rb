class Expense < ActiveRecord::Base
	#validations
	validates :transaction_date, :description, :category, :amount, presence: true

	scope :latest_expenses, -> { order("transaction_date DESC") }

	# TODO: you need to either call these transactions or expenses
	# it's confusing when you do both.
	scope :autos_expenses, -> { where(category: "Auto & Transportation") }
	scope :foods_expenses, -> { where(category: "Food & Dining") }
	scope :entertaiments_expenses, -> { where(category: "Entertaiment") }
	scope :bills_expenses, -> { where(category: "Bills & Utilities") }
	scope :investments_expenses, -> { where(category: "Investments") }
	scope :miscs_expenses, -> { where(category: "MISC") }
end