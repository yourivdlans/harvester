class MoneybirdSalesInvoice
  include ActiveModel::Model

  attr_accessor :contact_id, :harvest_project_ids

  validates :contact_id, :harvest_project_ids, presence: true

  def create(access_token:)
    return false if invalid?

    sales_invoice = Moneybird.new(access_token).create_sales_invoice(self)

    harvest_project_ids.each do |harvest_project_id|
      Project.find_by(harvest_project_id: harvest_project_id).sales_invoices.create!(moneybird_sales_invoice_id: sales_invoice['id'])
    end
  rescue Moneybird::Error => e
    errors.add(:base, e)

    false
  end
end
