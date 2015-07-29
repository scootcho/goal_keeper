class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
    	t.date :transaction_date, null: false
    	t.text :description, null: false
    	t.references :categories, null:false
    	t.decimal :amount, null: false
    end
  end
end
