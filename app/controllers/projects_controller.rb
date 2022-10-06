class ProjectsController < ApplicationController
  layout false

  def index
    @projects = Timesheet::Base.projects
  end

  def show
    @harvest_company = harvest_company
    @project = Timesheet::Base.project(params[:id]).tap(&:fetch_time_entries)
    @moneybird_sales_invoice = MoneybirdSalesInvoice.find_moneybird_sales_invoice(@project.id, moneybird_sales_invoices)
  end

  def destroy
    Harvest.new.archive_project(params[:id])
  end

  private

  def moneybird
    @moneybird ||= Moneybird.new(session[:moneybird_access_token])
  end

  def moneybird_sales_invoices
    return [] unless authenticated_with_moneybird?

    moneybird.sales_invoices_by_ids(SalesInvoice.pluck(:moneybird_sales_invoice_id).compact)
  end

  def harvest_company
    Rails.cache.fetch('harvest_company', expires_in: 12.hours) do
      Harvest.new.company
    end
  end
end
