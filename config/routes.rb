Rails.application.routes.draw do
  root to: 'pages#home'
  resources :goals
  resources :expenses
  get 'stats', to: 'expenses#stats'
end
