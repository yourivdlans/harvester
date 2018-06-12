class ProjectsController < ApplicationController
  layout false

  def index
    @projects = Timesheet::Base.new.build

    if authenticated_with_moneybird?
      @project_states = Moneybird.new(session[:moneybird_access_token]).project_states
    end

    @sales_invoice = SalesInvoice.new
  end

  def show
    @project = Timesheet::Project.new(
      id: params[:id]
    ).tap(&:fetch_time_entries)
  end
end
