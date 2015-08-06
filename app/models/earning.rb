class Earning < ActiveRecord::Base
	# validations
	validates :description, :amount, :earning_date, presence: true
	
	# initalize values
	after_create :defaults

	# scopes
	scope :earnings, -> { order("earning_date ASC") }

	def defaults
		self.payment_count = 0
	end
end