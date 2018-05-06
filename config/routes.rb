Rails.application.routes.draw do
  resources :projects, only: :index
  resources :sales_invoices, only: :create
  resources :creditcard_transactions, only: :create
  resources :creditcard_transaction_imports, only: [:new, :create]
  resource :moneybird, only: :show

  root 'projects#index'
end
