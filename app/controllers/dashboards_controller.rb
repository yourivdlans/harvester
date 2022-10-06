class DashboardsController < ApplicationController
  def index
    @moneybird_sales_invoice = MoneybirdSalesInvoice.new
  end
end
