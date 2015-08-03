class CreateIncome < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
    	t.date :income_date, null: false
    	t.text :description, null: false
    	t.string :increment_interval, null: false
    	t.decimal :amount, null: false
    end
  end
end