class ProjectsController < ApplicationController
  def index
    @projects = Timesheet::Base.new.build

    if authenticated_with_moneybird?
      @contacts = Moneybird.new(session[:moneybird_access_token]).contacts
      @project_states = Moneybird.new(session[:moneybird_access_token]).project_states
    end

    @sales_invoice = SalesInvoice.new
  end
end
