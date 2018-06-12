class MoneybirdsController < ApplicationController
  def show
    redirect_uri = "http://localhost:5000/moneybird"

    if params['code']
      access_token_params = {
        client_id: ENV.fetch('MONEYBIRD_CLIENT_ID'),
        client_secret: ENV.fetch('MONEYBIRD_CLIENT_SECRET'),
        code: params['code'],
        redirect_uri: redirect_uri,
        grant_type: 'authorization_code',
      }
      session[:moneybird_access_token] = JSON.parse(HTTP.post('https://moneybird.com/oauth/token', form: access_token_params).to_s)
      redirect_to root_path
      return
    end

    redirect_to "https://moneybird.com/oauth/authorize?client_id=#{ENV.fetch('MONEYBIRD_CLIENT_ID')}&redirect_uri=#{redirect_uri}&response_type=code&scope=sales_invoices bank"
  end
end
