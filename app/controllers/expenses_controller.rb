class ExpensesController < ApplicationController
  def stats
  end

  def index
    @expenses = Expense.latest_expenses
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_param)
    if @expense.save
      redirect_to expenses_path
    else
      render :new
    end
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update #TODO: Fix params error
    @expense = Expense.find(params[:id])
    if @expense.update(expense_param)
      redirect_to expense_path(@expense)
    else
      render :edit
    end
  end

  def auto_category
    @autos = Expense.autos_expenses
  end

  def food_category
    @foods = Expense.foods_expenses
  end

  def entertainment_category
    @entertainments = Expense.entertaiments_expenses
  end
  
  def bill_category
    @bills = Expense.bills_expenses
  end
  
  def investment_category
    @investments = Expense.investments_expenses
  end

  def misc_category
    @miscs = Expense.miscs_expenses
  end

  private
    def expense_param
      params.require(:expense).permit(:expense_date, :description, :category, :amount)
    end
end
