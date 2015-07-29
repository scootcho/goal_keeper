class Expense < ActiveRecord::Base
	#validations
	validates :transaction_date, :description, :amount, presence: true

	#relations
	has_many :categories
end