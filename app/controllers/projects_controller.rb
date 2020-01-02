class ProjectsController < ApplicationController
  layout false

  def index
    @projects = Timesheet::Base.new.build

    @moneybird_sales_invoices = authenticated_with_moneybird? ? moneybird.sales_invoices_by_ids(SalesInvoice.pluck(:moneybird_sales_invoice_id).compact) : []
    @harvest_company = Harvest.new.company
  end

  def show
    @project = Timesheet::Project.new(
      id: params[:id]
    ).tap(&:fetch_time_entries)
  end

  def destroy
    Harvest.new.archive_project(params[:id])
  end

  private

  def moneybird
    @moneybird ||= Moneybird.new(session[:moneybird_access_token])
  end
end
