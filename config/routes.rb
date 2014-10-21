Mywater::Application.routes.draw do

  root to: 'pages#root'
  resources :reservoir

end
