class RabobankCreditcardPdf
  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    data = File.read(@file_path)
    text = Yomu.read(:text, data)
    result = text.gsub(/\\n/, "\n")

    rows = result.scan(/(\d{2}-\d{2}-\d{4})\s(\w.*?)\s*?(-?\d{1,3},\d{2})\s*(-?\d{1,3},\d{2})?/)

    rows.map do |col|
      new_creditcard_transaction(col)
    end.compact
  end

  private

  def new_creditcard_transaction(params)
    if params[3].blank?
      amount = params[2]
      description = params[1]
    else
      amount = params[3]
      description = "#{params[1]} #{params[2]}"
    end

    return if amount[0] == '-'

    CreditcardTransaction.new(date: params[0], description: description, amount: amount)
  end
end
