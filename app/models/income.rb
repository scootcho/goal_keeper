class Income < ActiveRecord::Base
	#validations
	validates :description, :amount, :increment_interval, :income_date, presence: true

	scope :income_list, -> { order("income_date DESC") }
end