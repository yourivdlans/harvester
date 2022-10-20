class CreditcardTransactionImportsController < ApplicationController
  before_action :ensure_authenticated_with_moneybird

  def new
  end

  def create
    @creditcard_transaction_import = CreditcardTransactionImport.new(creditcard_transaction_import_params)
    @creditcard_transaction_import.creditcard_transactions = RabobankCreditcardPdf.new(@creditcard_transaction_import.pdf.tempfile).parse

    @financial_accounts = financial_accounts
  end

  private

  def ensure_authenticated_with_moneybird
    return if authenticated_with_moneybird?

    redirect_to root_path
  end

  def creditcard_transaction_import_params
    params.require(:creditcard_transaction_import).permit(:pdf)
  end

  def financial_accounts
    accounts = Moneybird.new(session[:moneybird_access_token]).financial_accounts
    accounts = accounts.select { |account| account['type'] == 'CreditCardAccount' }
    accounts.sort_by { |account| Time.parse(account['created_at']) }.reverse
  end
end
