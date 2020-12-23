class CreditcardTransaction
  include ActiveModel::Model

  attr_writer :date, :description, :amount

  def date
    Date.strptime(@date, '%d-%m-%Y')
  end

  def description
    @description.squish
  end

  def amount
    @amount.delete(' ').sub(',', '.').to_f
  end

  def negate_amount
    -amount
  end
end
