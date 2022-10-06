class MoneybirdContactsController < ApplicationController
  def index
    unless authenticated_with_moneybird?
      head :ok
      return
    end

    @contacts = Moneybird.new(session[:moneybird_access_token]).contacts(params[:q])

    render layout: false
  end
end
