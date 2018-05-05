class Moneybird
  class Error < StandardError
    attr_reader :code

    def initialize(message = nil, code = nil)
      @message = message
      @code = code
    end

    def to_s
      @message
    end
  end

  def initialize(access_token)
    @access_token = access_token

    @base_uri = "https://moneybird.com/api/v2/#{ENV.fetch('MONEYBIRD_ADMINISTRATION_ID')}/"
  end

  def administrations
    response = HTTP.headers(auth_headers).get("#{@base_uri}/administrations.json")

    parse_response(response)
  end

  def contacts
    response = HTTP.headers(auth_headers).get("#{@base_uri}/contacts.json")

    parse_response(response)
  end

  def create_sales_invoice(sales_invoice)
    payload = {
      sales_invoice: {
        contact_id: sales_invoice.contact_id
      }
    }
    payload[:sales_invoice][:details_attributes] = build_details_attributes(sales_invoice)

    response = HTTP.headers(auth_headers).post("#{@base_uri}/sales_invoices.json", json: payload)

    parse_response(response)
  end

  private

  def parse_response(response)
    json = JSON.parse(response.to_s)

    raise Moneybird::Error.new(json['error'], response.status.code) unless response.status.code.between?(200, 299)

    json
  end

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

    Timesheet::Base.new_project(project)
  end
end
