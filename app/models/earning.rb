class Earning < ActiveRecord::Base
	#flush cached queries when data is created/updated/destoryed
  after_create :flush_cache
  after_update :flush_cache
  after_destroy :flush_cache

	# validations
	validates :description, :amount, :earning_date, presence: true
	
	# initalize values
	after_create :defaults

	# scopes
	scope :earnings, -> { order("earning_date ASC") }
	
  def self.order_by_earliest
    Rails.cache.fetch("earnings_order_by_earliest_cached") { order("earning_date ASC") }
  end

	def defaults
		self.payment_count = 0
	end

	private

    def flush_cache
      Rails.cache.delete("earnings_order_bye_earliest_cached")
    end
end