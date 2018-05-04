class SalesInvoice
  include ActiveModel::Model

  attr_accessor :contact_id, :project_id, :sales_invoice_details

  validates :contact_id, :project_id, presence: true

  def save(access_token:)
    return false if invalid?

    Moneybird.new(access_token).create_sales_invoice(self)
  rescue Moneybird::Error => e
    errors.add(:base, e)

    false
  end
end
