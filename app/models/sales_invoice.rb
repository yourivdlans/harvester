class SalesInvoice
  include ActiveModel::Model

  attr_accessor :contact_id, :project_id, :sales_invoice_details

  validates :contact_id, :project_id, presence: true

  def save(access_token:)
    return false if invalid?

    sales_invoice = Moneybird.new(access_token).create_sales_invoice(self)

    project_id.each do |harvest_project_id|
      Project.find_by(harvest_project_id: harvest_project_id).update!(moneybird_sales_invoice_id: sales_invoice['id'])
    end
  rescue Moneybird::Error => e
    errors.add(:base, e)

    false
  end
end
