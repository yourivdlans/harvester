class Harvest
  def initialize
    @base_uri = 'https://api.harvestapp.com/api/v2/'
  end

  def entries
    response = HTTP.headers(auth_headers).get("#{@base_uri}/time_entries.json", params: { 'is_billed' => 'false' })

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
