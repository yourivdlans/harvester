class Harvest
  def initialize
    @base_uri = 'https://api.harvestapp.com/api/v2/'
  end

  def projects(params = {})
    params.merge!(is_active: 'true')

    response = HTTP.headers(auth_headers).get("#{@base_uri}/projects.json", params: params)

    JSON.parse(response.to_s)
  end

  def time_entries(params = {})
    params.merge!(is_billed: 'false')

    response = HTTP.headers(auth_headers).get("#{@base_uri}/time_entries.json", params: params)

    JSON.parse(response.to_s)
  end

  private

  def auth_headers
    {
      'Harvest-Account-ID' => ENV.fetch('HARVEST_ID'),
      'Authorization' => "Bearer #{ENV.fetch('HARVEST_TOKEN')}",
      'User-Agent' => 'Harvester'
    }
  end
end
