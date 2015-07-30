Rails.application.routes.draw do
  root to: 'pages#home'
  resources :goals, :expenses
  get 'statistics', to: 'expenses#stats'
  get 'auto_transportation', to: 'expenses#auto_category'
	get 'food_and_dining', to: 'expenses#food_category'
	get 'entertainments', to: 'expenses#entertainment_category'
	get 'bills_and_utilities', to: 'expenses#bill_category'
	get 'investments', to: 'expenses#investment_category'
	get 'miscellaneous', to: 'expenses#misc_category'
end