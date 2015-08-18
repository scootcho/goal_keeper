class Goal < ActiveRecord::Base
	#validations
	validates :title, :amount, :due_date, presence: true

	#scopes
	scope :due_soonest, -> { order("due_date ASC") }

	#current_goal is to identify what the current goal is.
	#There will be an option in the interface for user to select next next targeted goal.
  def self.current_goal
    goals = Goal.calculate_goals_begin_end_dates
    today = Date.today
    array_position = []
    goals.each_with_index do |day, index|
      if today < day[:begin_date]
        array_position << index
        break
      end
    end
    current_position = array_position[0] - 1
    goal = Goal.find(goals[current_position][:id])

    while Goal.is_success?(goal)
      goal = Goal.find(goals[current_position + 1][:id])
      current_position += 1
    end
    goal
  end

	def self.calculate_goals_begin_end_dates
		ordered = Goal.order("due_date ASC")
		num_goals = ordered.count
		begin_dates	= []
		counter = 1
		#first goal will use create date as begin date
		if ordered[0].created_at < Date.today
			begin_dates << { id: ordered[0].id, begin_date: ordered[0].created_at.to_date, due_date: ordered[0].due_date, amount: ordered[0].amount }
		else
			begin_dates << { id: ordered[0].id, begin_date: ordered[0].due_date, due_date: ordered[0].due_date, amount: ordered[0].amount }
		end

		while counter < num_goals
			begin_dates << { id: ordered[counter].id, begin_date: ordered[counter - 1].due_date + 1.day, due_date: ordered[counter].due_date, amount: ordered[counter].amount }
			counter += 1
		end
		begin_dates
	end

	def self.days_until_current_goal
		current = Goal.current_goal
		time_left = current.due_date - Date.today
		time_left.round
	end

	#total earnings - total expenses = disposable cash available
	def self.net_cash_to_date(goal)
		goal_dates = Goal.calculate_goals_begin_end_dates
		select = goal.id
		goal_date = goal_dates.select { |a| a[:id] == goal.id }
		earnings_ordered = Earning.order("earning_date ASC")
		expenses_ordered = Expense.order("earning_date ASC")
		begin_date = goal_date[0][:begin_date]
		end_date = goal_date[0][:due_date]
		earnings_to_date = earnings_ordered.where("earning_date BETWEEN ? AND ?", begin_date, end_date).sum(:amount)
		expenses_to_date = expenses_ordered.where("expense_date BETWEEN ? AND ?", begin_date, end_date).sum(:amount)
		net_cash = earnings_to_date.to_f - expenses_to_date.to_f
	end

	def self.is_success?(goal)
		#the net_cash_to_date needs a beginning
		if goal.amount < Goal.net_cash_to_date(goal)
			true
		else
			false
		end
	end

	#how much remaining is needed to get to the current goal.
	def self.remaining_goal
		goal = Goal.current_goal
		remaining_goal = goal.amount - Goal.net_cash_to_date(goal)
		remaining_goal
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