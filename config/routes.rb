Rails.application.routes.draw do
  resource :dashboard, only: :index
  resources :projects, only: [:index, :show, :destroy]
  resources :moneybird_sales_invoices, only: :create
  resources :moneybird_contacts, only: :index
  resources :creditcard_transactions, only: :create
  resources :creditcard_transaction_imports, only: [:new, :create]
  resource :moneybird, only: :show

  root 'dashboards#index'
end
