class CreditcardTransactionsController < ApplicationController
  before_action :ensure_authenticated_with_moneybird

  def create
    @creditcard_transaction_import = CreditcardTransactionImport.new(creditcard_transaction_import_params)

    @financial_statement = Moneybird.new(session[:moneybird_access_token]['access_token']).create_financial_statement(@creditcard_transaction_import)

    redirect_to new_creditcard_transaction_import_path, notice: 'Creditcard transactions have been imported'
  rescue Moneybird::Error => e
    redirect_to new_creditcard_transaction_import_path, alert: "Moneybird error: #{e}"
  end

  private

  def ensure_authenticated_with_moneybird
    return if authenticated_with_moneybird?

    redirect_to projects_path
  end

  def creditcard_transaction_import_params
    params.require(:creditcard_transaction_import).permit(
      :financial_account_id,
      creditcard_transactions_attributes: [
        :date,
        :description,
        :amount
      ]
    )
  end
end
