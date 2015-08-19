class Goal < ActiveRecord::Base
	#validations
	validates :title, :amount, :due_date, presence: true

	#scopes
	scope :due_soonest, -> { order("due_date ASC") }

	#current_goal is to identify what the current goal is.
	#There will be an option in the interface for user to select next next targeted goal.
  def self.current_goal(date)
    goals = Goal.calculate_goals_begin_end_dates
    array_position = []
    goals.each_with_index do |day, index|
      if date < day[:begin_date]
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

	#total earnings - total expenses = disposable cash available
	def self.net_cash_to_date(goal)
		goal_dates = Goal.calculate_goals_begin_end_dates
		select = goal.id
		goal_date = goal_dates.select { |a| a[:id] == goal.id }
		earnings_ordered = Earning.order("earning_date ASC")
		expenses_ordered = Expense.order("earning_date ASC")
		begin_date = goal_date[0][:begin_date]
		due_date = goal_date[0][:due_date]
		earnings_to_date = earnings_ordered.where("earning_date BETWEEN ? AND ?", begin_date, due_date).sum(:amount)
		expenses_to_date = expenses_ordered.where("expense_date BETWEEN ? AND ?", begin_date, due_date).sum(:amount)
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

	#dollar amount remaining to get to the current goal.
	def self.remaining_goal(date)
		goal = Goal.current_goal(date)
		remaining_goal = goal.amount - Goal.net_cash_to_date(goal)
		remaining_goal
	end

	def self.projected_earnings_within_current_goal(date)
		current_goal = Goal.current_goal(date)
		goal_dates = Goal.calculate_goals_begin_end_dates
		goal_date = goal_dates.select { |a| a[:id] == current_goal.id }
		begin_date = goal_date[0][:begin_date]
		due_date = goal_date[0][:due_date]

		arr = Earning.order("earning_date ASC")
		arr.where("earning_date BETWEEN ? AND ?", begin_date, due_date)
	end

	def self.one_earning_after_current_goal(date)
		arr = Earning.order("earning_date ASC")
		arr.where("earning_date > ? ", Goal.current_goal(date).due_date).limit(1)
	end

	def self.sum_of_earnings_within_current_goal(date)
		Goal.projected_earnings_within_current_goal(date).sum(:amount).to_f
	end

	def self.weighted_earning_per_period(date)
		denominator = Goal.sum_of_earnings_within_current_goal(date)
		arr = []
		Goal.projected_earnings_within_current_goal(date).each do |earning|
			weighted = earning.amount / denominator
			arr << {earning_id: earning.id, weighted: weighted.to_f}
		end
		arr
	end

	def self.weighted_goal_per_period(date)
		remaining = Goal.remaining_goal(date)
		if remaining == nil
			puts "you have exceeded the current goal!"
			#TODO: implement next goal here
		else
			#weighted_amount is goal amount for a pay period
			Goal.weighted_earning_per_period(date).map do |arr|
				{ earning_id: arr[:earning_id], weighted: arr[:weighted], weighted_amount: arr[:weighted] * remaining }
			end
		end
	end

	def self.diff_between_earning_dates(date)
		arr = Goal.projected_earnings_within_current_goal(date)
		num_payments = arr.count
		arr << Goal.one_earning_after_current_goal(date)[0]
		counter = 0
		result = []
		while counter < num_payments do
			date_diff = arr[counter][:earning_date] - arr[counter + 1][:earning_date]
			result << { earning_id: arr[counter][:id], earning_date: arr[counter][:earning_date], date_diff: date_diff.round }
			counter += 1
		end
		result
	end

	def self.date_falls_within_earning_period(date)
		ordered = Goal.projected_earnings_within_current_goal(date)
		array_position = []
		ordered.each_with_index do |day, index|
			if date < day[:earning_date]
				array_position << index
				break
			end
		end
		current_position = array_position[0] - 1
		ordered[current_position]
	end

	def self.daily_spending_limit(date)
		earning_period =	Goal.date_falls_within_earning_period(date)
		earning_id = earning_period[:id]
		earning_date = earning_period[:earning_date]

		amount = Goal.weighted_goal_per_period(date).select do |hash|
		    hash[:earning_id] == earning_id
		end

		diff_date =	Goal.diff_between_earning_dates(date).select do |hash|
		    hash[:earning_id] == earning_id
		end

		amount_per_period = amount[0][:weighted_amount]
		days_per_period = diff_date[0][:date_diff].abs

		amount_per_period / days_per_period
	end

	def self.day_target_met(date)
		expense = Expense.expense_for_date(date)
		limit = Goal.daily_spending_limit(date)
		if  expense == 0
			return nil
		elsif expense < limit
			true
		else
			false
		end
	end
end