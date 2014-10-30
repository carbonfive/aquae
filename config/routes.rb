Aquae::Application.routes.draw do

  root to: 'pages#root'
  resources :reservoir
  resources :water_system
end
