Rails.application.routes.draw do
  root to: 'pages#home'
  resources :goals, :expenses, :categories
  get 'stats', to: 'expenses#stats'
end
