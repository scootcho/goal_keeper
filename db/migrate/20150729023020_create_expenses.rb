class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :expense_date, null: false
      t.text :description, null: false
      t.text :category, null: false
      t.decimal :amount, null: false
    end
    add_index :expenses, :category
  end
end
