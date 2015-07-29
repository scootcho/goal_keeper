class Category < ActiveRecord::Base
	#validations
	validates :name, presence: true

	#relations
	belongs_to :expense
end