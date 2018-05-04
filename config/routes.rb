Rails.application.routes.draw do
  resources :projects, only: :index
  resources :sales_invoices, only: :create
  resource :moneybird, only: :show
end
