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
      @projects = Timesheet::Base.new.build
      @contacts = Moneybird.new(session[:moneybird_access_token]['access_token']).contacts
      @project_states = Moneybird.new(session[:moneybird_access_token]['access_token']).project_states

      flash[:alert] = 'Sales invoice could not be created.'

      render template: 'projects/index'
    end
  end

  private

  def sales_invoice_params
    params.require(:sales_invoice).permit(:contact_id, project_id: [])
  end
end
