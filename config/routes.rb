Rails.application.routes.draw do
  get :signup, to: 'users#new'
  post :signup, to: 'users#create'
  get :login, to: 'sessions#new'
  post :login, to: 'sessions#create'
  delete :logout, to: 'sessions#destroy'

  resources :users, only: %i[new create] do
    resources :spendings
  end

  resources :categories

  root 'home_page#index'
end
