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

  def financial_accounts
    response = HTTP.headers(auth_headers).get("#{@base_uri}/financial_accounts.json")

    parse_response(response)
  end

  def create_financial_statement(creditcard_transaction_import)
    payload = {
      financial_statement: {
        financial_account_id: creditcard_transaction_import.financial_account_id,
        reference: "Imported on #{I18n.localize(Time.zone.now, format: :long)}",
      }
    }
    payload[:financial_statement][:financial_mutations_attributes] = build_financial_mutations_attributes(creditcard_transaction_import)

    HTTP.headers(auth_headers).post("#{@base_uri}/financial_statements.json", json: payload)
  end

  def contacts
    response = HTTP.headers(auth_headers).get("#{@base_uri}/contacts.json")

    parse_response(response)
  end

  def sales_invoices(params = {})
    response = HTTP.headers(auth_headers).get("#{@base_uri}/sales_invoices.json", params: params)

    parse_response(response)
  end

  def sales_invoices_by_ids(ids)
    response = HTTP.headers(auth_headers).post("#{@base_uri}/sales_invoices/synchronization.json", json: { ids: ids })

    parse_response(response)
  end

  def create_sales_invoice(sales_invoice)
    payload = {
      sales_invoice: {
        contact_id: sales_invoice.contact_id,
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
      'Authorization' => "Bearer #{@access_token}",
    }
  end

  def build_details_attributes(sales_invoice)
    attributes = {}

    sales_invoice.harvest_project_ids.each_with_index do |harvest_project_id, i|
      project = harvest_project(harvest_project_id)

      attributes[:"#{i}"] = {
        description: project.name,
        price: project.amount,
        period: project.period,
      }
    end

    attributes
  end

  def build_financial_mutations_attributes(creditcard_transaction_import)
    attributes = {}

    creditcard_transaction_import.creditcard_transactions.each_with_index do |transaction, i|
      attributes[:"#{i}"] = {
        date: transaction.date.iso8601,
        message: transaction.description,
        amount: transaction.amount
      }
    end

    attributes
  end

  def harvest_project(id)
    project = Harvest.new.project(id)

    Timesheet::Base.new_project(project).tap(&:fetch_time_entries)
  end
end
