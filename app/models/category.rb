class Category < ActiveRecord::Base
	#validations
	valdates :name, presence: true

	#relations
	belongs_to :expense
end