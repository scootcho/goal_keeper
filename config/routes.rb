Rails.application.routes.draw do
  root to: 'goals#home'
  get 'next_week', to: 'goals#next_week', as: 'next_week'
  get 'prev_week', to: 'goals#prev_week', as: 'prev_week'

  get 'calendar', to: 'goals#current_month', as: 'calendar'
  get 'next_month', to: 'goals#next_month', as: 'next_month'
  get 'prev_month', to: 'goals#prev_month', as: 'prev_month'

  resources :goals

  resources :expenses

  resources :income
  get 'income_list', to: 'income#index'

  get 'statistics', to: 'expenses#stats'
  get 'auto_transportation', to: 'expenses#auto_category'
	get 'food_and_dining', to: 'expenses#food_category'
	get 'entertainments', to: 'expenses#entertainment_category'
	get 'bills_and_utilities', to: 'expenses#bill_category'
	get 'investments', to: 'expenses#investment_category'
	get 'miscellaneous', to: 'expenses#misc_category'
end