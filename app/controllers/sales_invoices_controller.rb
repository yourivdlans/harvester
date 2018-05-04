class SalesInvoicesController < ApplicationController
  def create
    unless authenticated_with_moneybird?
      redirect_to projects_path
      return
    end

    @sales_invoice = SalesInvoice.new(sales_invoice_params)

    if @sales_invoice.save(access_token: session[:moneybird_access_token]['access_token'])
      redirect_to projects_path, notice: 'Sales invoice has been created.'
    else
      redirect_to projects_path, error: 'Sales invoice could not be created.'
    end
  end

  private

  def sales_invoice_params
    params.require(:sales_invoice).permit(:contact_id, project_id: [])
  end
end