class Goal < ActiveRecord::Base
	#validations
	validates :title, :amount, :due_date, presence: true

	#scopes
	scope :due_soonest, -> { order("due_date ASC") }

	scope :current_goal, -> { order("due_date ASC").first }

	def self.days_until_current_goal
		current = Goal.current_goal
		time_left = current.due_date - Date.today
		time_left.round
	end

	def self.net_cash_to_date
		earnings_ordered = Earning.order("earning_date ASC")
		expenses_ordered = Expense.order("earning_date ASC")
		today = Date.today
		earnings_to_date = earnings_ordered.where("earning_date < ? ", today).sum(:amount)
		expenses_to_date = expenses_ordered.where("expense_date < ? ", today).sum(:amount)
		net_cash = earnings_to_date - expenses_to_date
	end

	def self.remaining_goal
		remaining_goal = Goal.current_goal.amount - Goal.net_cash_to_date
		if remaining_goal > 0
			remaining_goal.to_f
		else
			# exeeded goal amount
			#TODO: implement next goal once current_goal is exceeded
			puts "you've exceeded your goal by $#{remaining_goal.abs.to_f}!!"
		end
	end

	def self.projected_earnings_within_current_goal
		arr = Earning.order("earning_date ASC")
		arr.where("earning_date < ? ", Goal.current_goal.due_date)
	end

	def self.one_earning_after_current_goal
		arr = Earning.order("earning_date ASC")
		arr.where("earning_date > ? ", Goal.current_goal.due_date).limit(1)
	end

	def self.sum_of_earnings_within_current_goal
		Goal.projected_earnings_within_current_goal.sum(:amount).to_f
	end

	def self.number_of_earnings_within_current_goal
		Goal.projected_earnings_within_current_goal.count 
	end
	
	def self.weighted_earning_per_period
		denominator = Goal.sum_of_earnings_within_current_goal
		arr = []
		Goal.projected_earnings_within_current_goal.each do |earning|
			weighted = earning.amount / denominator
			arr << {earning_id: earning.id, weighted: weighted.to_f}
		end
		arr
	end

	def self.weighted_goal_per_period
		remaining = Goal.remaining_goal
		if remaining == nil
			puts "you have exceeded the current goal!"
			#TODO: implement next goal here
		else
			#weighted_amount is goal amount for a pay period
			Goal.weighted_earning_per_period.map do |arr|
				{ earning_id: arr[:earning_id], weighted: arr[:weighted], weighted_amount: arr[:weighted] * remaining }
			end
		end
	end

	def self.diff_between_earning_dates
		arr = Goal.projected_earnings_within_current_goal
		num_payments = arr.count
		arr << Goal.one_earning_after_current_goal[0]
		counter = 0
		result = []
		while counter < num_payments do
			date_diff = arr[counter][:earning_date] - arr[counter + 1][:earning_date]
			result << { earning_id: arr[counter][:id], earning_date: arr[counter][:earning_date], date_diff: date_diff.round }
			counter += 1
		end
		result
	end

	def self.today_falls_within_earning_period
		ordered = Goal.projected_earnings_within_current_goal
		today = Date.today
		array_position = []
		ordered.each_with_index do |day, index|
			if today < day[:earning_date]
				array_position << index
				break
			end
		end
		current_position = array_position[0] - 1
		ordered[current_position]
	end

	def self.daily_spending_limit
		earning_period =	Goal.today_falls_within_earning_period
		earning_id = earning_period[:id]
		earning_date = earning_period[:earning_date]

		amount = Goal.weighted_goal_per_period.select do |hash|
		    hash[:earning_id] == earning_id
		end

		diff_date =	Goal.diff_between_earning_dates.select do |hash|
		    hash[:earning_id] == earning_id
		end

		amount_per_period = amount[0][:weighted_amount]
		days_per_period = diff_date[0][:date_diff].abs

		amount_per_period / days_per_period
	end
end