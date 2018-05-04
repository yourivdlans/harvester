class Moneybird
  def initialize(access_token)
    @access_token = access_token

    @base_uri = "https://moneybird.com/api/v2/#{ENV.fetch('MONEYBIRD_ADMINISTRATION_ID')}/"
  end

  def contacts
    response = HTTP.headers(auth_headers).get("#{@base_uri}/contacts.json")

    JSON.parse(response.to_s)
  end

  def create_sales_invoice(sales_invoice)
    payload = {
      sales_invoice: {
        contact_id: sales_invoice.contact_id
      }
    }
    payload[:sales_invoice][:details_attributes] = build_details_attributes(sales_invoice)

    response = HTTP.headers(auth_headers).post("#{@base_uri}/sales_invoices.json", json: payload)

    JSON.parse(response.to_s)
  end

  private

  def auth_headers
    {
      'Authorization' => "Bearer #{@access_token}"
    }
  end

  def build_details_attributes(sales_invoice)
    attributes = {}

    sales_invoice.project_id.each_with_index do |project_id, i|
      project = harvest_project(project_id)

      attributes[:"#{i}"] = {
        description: project.name,
        price: project.amount
      }
    end

    attributes
  end

  def harvest_project(id)
    project = Harvest.new.project(id)

    Timesheet::Project.new(id: project['id'], name: project['name'], client: project['client']).tap do |prj|
      prj.fetch_time_entries
    end
  end
end
