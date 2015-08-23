class Expense < ActiveRecord::Base
  #flush cached queries when data is created/updated/destoryed
  after_create :flush_cache
  after_update :flush_cache
  after_destroy :flush_cache

	#validations
	validates :expense_date, :description, :category, :amount, presence: true

	scope :latest_expenses, -> { order("expense_date DESC") }

	scope :autos_expenses, -> { where(category: "Auto & Transportation") }
	scope :foods_expenses, -> { where(category: "Food & Dining") }
	scope :entertaiments_expenses, -> { where(category: "Entertaiment") }
	scope :bills_expenses, -> { where(category: "Bills & Utilities") }
	scope :investments_expenses, -> { where(category: "Investments") }
	scope :miscs_expenses, -> { where(category: "MISC") }

  def self.order_by_earliest
    Rails.cache.fetch("expenses_order_by_earliest_cached") { order("expense_date ASC") }
  end

  def self.expense_for_date(date)
  	beginning_of_day = date.beginning_of_day
  	end_of_day = date.end_of_day
  	Expense.where('expense_date BETWEEN ? AND ?', beginning_of_day, end_of_day).sum(:amount)
  end

  private

    def flush_cache
      Rails.cache.delete("expenses_order_bye_earliest_cached")
    end
end