Rails.application.routes.draw do
  resources :posts

  resources :advertisements

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
