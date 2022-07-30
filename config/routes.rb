Rails.application.routes.draw do
  get 'p/:id', to: 'profile#show'
  post 'profile/follow', to: 'profile#follow'
  delete 'profile/unfollow', to: 'profile#unfollow'
  
  resources :posts
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'home#index'
end
