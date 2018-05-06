class CreditcardTransactionImport
  include ActiveModel::Model

  attr_accessor :financial_account_id, :pdf, :creditcard_transactions

  def creditcard_transactions_attributes=(attributes)
    @creditcard_transactions ||= []
    attributes.each do |_i, creditcard_transaction_params|
      @creditcard_transactions.push(CreditcardTransaction.new(creditcard_transaction_params))
    end
  end
end
