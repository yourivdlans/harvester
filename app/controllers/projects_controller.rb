class ProjectsController < ApplicationController
  def index
    @projects = Timesheet::Base.new.build

    if authenticated_with_moneybird?
      @contacts = Moneybird.new(session[:moneybird_access_token]['access_token']).contacts
      @paid_projects = Moneybird.new(session[:moneybird_access_token]['access_token']).paid_projects
    end

    @sales_invoice = SalesInvoice.new
  end
end
