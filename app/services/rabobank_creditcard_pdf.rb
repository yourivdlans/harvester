class RabobankCreditcardPdf
  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    data = File.read(@file_path)
    text = Henkei.read(:text, data)

    date = /(\d{2}-\d{2}-\d{4})/
    number = /((?:-\s)?\d{1,3},\d{2})/

    rows = text.scan(/#{date}\s(.*?#{number})\n\n(?:Koers\s\d?\.\d{1,10}\n\n)?#{number}?/)

    rows.map do |col|
      new_creditcard_transaction(col)
    end.compact
  end

  private

  def new_creditcard_transaction(params)
    amount = amount_from_params(params)
    description = params[1]

    return if description.downcase.include?('vorig overzicht')
    return if description.downcase.include?('koersopslag')

    CreditcardTransaction.new(date: params[0], description: description, amount: amount)
  end

  def amount_from_params(params)
    if params[2].blank? && params[3].blank?
      '0,00'
    elsif params[3].present?
      params[3]
    else
      params[2]
    end
  end
end
