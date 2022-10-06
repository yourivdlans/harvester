class MoneybirdSalesInvoicesController < ApplicationController
  def create
    unless authenticated_with_moneybird?
      redirect_to root_path
      return
    end

    @moneybird_sales_invoice = MoneybirdSalesInvoice.new(moneybird_sales_invoice_params)

    if @moneybird_sales_invoice.create(access_token: session[:moneybird_access_token])
      redirect_to root_path, notice: 'Sales invoice has been created.'
    else
      @projects = Timesheet::Base.projects
      @moneybird_sales_invoices = Moneybird.new(session[:moneybird_access_token]).sales_invoices_by_ids(SalesInvoice.pluck(:moneybird_sales_invoice_id).compact)

      flash[:alert] = 'Sales invoice could not be created.'

      render template: 'dashboards/index'
    end
  end

  private

  def moneybird_sales_invoice_params
    params.require(:moneybird_sales_invoice).permit(:contact_id, harvest_project_ids: [])
  end
end
