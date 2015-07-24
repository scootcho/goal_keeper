class Goal < ActiveRecord::Base
	#validations
	validates :title, :amount, :due_date, presence: true

	#scopes
	scope :due_soonest, -> { order("due_date ASC") }
end
