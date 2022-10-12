Rails.application.routes.draw do
  get :signup, to: 'users#new'
  post :signup, to: 'users#create'
  get :login, to: 'sessions#new'
  post :login, to: 'sessions#create'
  delete :logout, to: 'sessions#destroy'

  resources :users, except: %i[index new] do
    resources :spendings
  end

  resources :categories

  root 'home_page#index'
end
