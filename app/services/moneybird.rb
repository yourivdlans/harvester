class Moneybird
  def initialize(access_token)
    @access_token = access_token

    @base_uri = "https://moneybird.com/api/v2/#{ENV.fetch('MONEYBIRD_ADMINISTRATION_ID')}/"
  end

  def contacts
    response = HTTP.headers(auth_headers).get("#{@base_uri}/contacts.json")

    JSON.parse(response.to_s)
  end

  def create_sale_invoice
    response = HTTP.headers(auth_headers).post("#{@base_uri}/sales_invoices.json", json: {
      sales_invoice: {
        contact_id: '123457166121108666',
        details_attributes: {
          :"0" => {
            description: 'test',
            price: '1'
          }
        }
      }
    })

    JSON.parse(response.to_s)
  end

  private

  def auth_headers
    {
      'Authorization' => "Bearer #{@access_token}"
    }
  end
end
