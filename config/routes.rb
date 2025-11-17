Rails.application.routes.draw do
  get "consents/toggle"
  get "users/show"
  resources :users, only: [:show]
  post 'consents/toggle', to: 'consents#toggle'
  root to: redirect("/users/#{User.first.id}")
end