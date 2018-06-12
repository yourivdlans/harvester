class DashboardsController < ApplicationController
  def index
    @sales_invoice = SalesInvoice.new
  end

  def submit_form
    unless authenticated_with_moneybird?
      head :ok
      return
    end

    @contacts = Moneybird.new(session[:moneybird_access_token]).contacts

    render :submit_form, layout: false
  end
end
