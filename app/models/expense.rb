class Expense < ActiveRecord::Base
	#validations
	validates :expense_date, :description, :category, :amount, presence: true

	scope :latest_expenses, -> { order("expense_date DESC") }

	scope :autos_expenses, -> { where(category: "Auto & Transportation") }
	scope :foods_expenses, -> { where(category: "Food & Dining") }
	scope :entertaiments_expenses, -> { where(category: "Entertaiment") }
	scope :bills_expenses, -> { where(category: "Bills & Utilities") }
	scope :investments_expenses, -> { where(category: "Investments") }
	scope :miscs_expenses, -> { where(category: "MISC") }

  scope :expense_today, -> { where('expense_date BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).sum(:amount) }
end