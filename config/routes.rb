Rails.application.routes.draw do
  resources :posts

  resources :advertisements

  resources :questions

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
