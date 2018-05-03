Rails.application.routes.draw do
  resources :projects, only: :index
  resource :moneybird, only: :show
end
