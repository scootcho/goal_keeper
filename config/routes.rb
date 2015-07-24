Rails.application.routes.draw do
  root to: 'pages#home'
  resources :goals
end
