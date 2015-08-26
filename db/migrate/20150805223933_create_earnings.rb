class CreateEarnings < ActiveRecord::Migration
  def change
    create_table :earnings do |t|
      t.date :earning_date, null: false
      t.text :description, null: false
      t.string :interval, null: false
      t.string :payment_count, null: false
      t.string :number_of_payments, null: false
      t.decimal :amount, null: false
    end
  end
end
