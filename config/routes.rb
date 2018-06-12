Rails.application.routes.draw do
  resource :dashboard, only: :index do
    get :submit_form
  end
  resources :projects, only: :index
  resources :sales_invoices, only: :create
  resources :creditcard_transactions, only: :create
  resources :creditcard_transaction_imports, only: [:new, :create]
  resource :moneybird, only: :show

  root 'dashboards#index'
end
