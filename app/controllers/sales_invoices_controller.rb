class SalesInvoicesController < ApplicationController
  def create
    unless authenticated_with_moneybird?
      redirect_to root_path
      return
    end

    @sales_invoice = SalesInvoice.new(sales_invoice_params)

    if @sales_invoice.save(access_token: session[:moneybird_access_token])
      redirect_to root_path, notice: 'Sales invoice has been created.'
    else
      @projects = Timesheet::Base.new.build
      @sales_invoices = Moneybird.new(session[:moneybird_access_token]).sales_invoices_by_ids(Project.pluck(:moneybird_sales_invoice_id).compact)

      flash[:alert] = 'Sales invoice could not be created.'

      render template: 'dashboards/index'
    end
  end

  private

  def sales_invoice_params
    params.require(:sales_invoice).permit(:contact_id, project_id: [])
  end
end
