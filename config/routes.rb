Rails.application.routes.draw do
  resources :users, only: [:index, :show, :new, :create]
  post 'consents/toggle', to: 'consents#toggle'
  get 'consents/history/:user_id', to: 'consents#history', as: 'consents_history'
  root 'users#index'
end