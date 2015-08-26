require 'rails_helper'

describe Goal do
  context "is valid" do
    it "has a title, amount and due_date" do
      expect(build(:goal)).to be_valid
    end

    it "without an uploaded image" do
      expect(build(:goal, filepicker_url: nil))
    end
  end

  context "is invalid" do
    it "without a title" do
      goal = build(:goal, title: nil)
      goal.valid?
      expect(goal.errors[:title]).to include("can't be blank")
    end

    it "with more than 50 characters" do
      goal = build(:goal, title: "a" * 51)
      goal.valid?
      expect(goal.errors[:title]).to include("make a concise goal with less than 50 words!")
    end

    it "without an amount" do
      goal = build(:goal, amount: nil)
      goal.valid?
      expect(goal.errors[:amount]).to include("can't be blank")
    end

    it "with a negative amount" do
      goal = build(:goal, amount: -1)
      goal.valid?
      expect(goal.errors[:amount]).to include("must be greater than 0")
    end

    it "without a due_date" do
      goal = build(:goal, due_date: nil)
      goal.valid?
      expect(goal.errors[:due_date]).to include("can't be blank")
    end
  end

  describe "returns a list of goals with dates" do
    let!(:goal_1) { create(:goal, due_date: Date.parse('2015-03-1')) }
    let!(:goal_2) { create(:goal, due_date: Date.parse('2015-01-1')) }
    let!(:goal_3) { create(:goal, due_date: Date.parse('2015-02-1')) }
    let!(:goal_4) { create(:goal, due_date: Date.parse('2015-05-1')) }
    let!(:goal_5) { create(:goal, due_date: Date.parse('2015-04-1')) }

    it "ordered by acending due_date" do
      expect(Goal.order_by_due_earliest).to eq([goal_2, goal_3, goal_1, goal_5, goal_4 ])
    end

    it "with begin dates in array of hashes" do
      goals = Goal.calculate_goals_begin_end_dates
      goals.each do |goal|
        expect(goal).to include(:begin_date)
      end
    end

    it "with first goal calculated using create_at as begin_date" do
      goals = Goal.calculate_goals_begin_end_dates
      expect(goals.first[:begin_date]).to eq(Date.parse('2015-01-1'))
    end
  end

  describe "returns a current_goal" do
    it "evaluates if current_goal is met"
    it "jumps to next available goal"
    it "stops at the last goal if completed"
  end
end