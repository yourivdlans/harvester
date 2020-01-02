class MoneybirdSalesInvoice
  include ActiveModel::Model

  attr_accessor :contact_id, :harvest_project_ids, :json_payload

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

  def state
    return 'unknown' if json_payload.blank?
    return 'uninvoiced' if json_payload == false

    json_payload['state']
  end

  def sales_invoice_url
    URI::HTTPS.build(
      host: 'moneybird.com',
      path: "/#{json_payload['administration_id']}/sales_invoices/#{json_payload['id']}"
    ).to_s
  end

  def self.find_moneybird_sales_invoice(project_id, moneybird_sales_invoices)
    json_payload = moneybird_sales_invoices.find do |moneybird_sales_invoice|
      sales_invoice = SalesInvoice.joins(:project).where(projects: { harvest_project_id: project_id }).newest_first.take
      next if sales_invoice.blank?

      moneybird_sales_invoice['id'] == sales_invoice.moneybird_sales_invoice_id
    end

    json_payload = false if json_payload.blank?

    new(json_payload: json_payload)
  end
end
