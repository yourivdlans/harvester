class ProjectsController < ApplicationController
  def index
    @projects = Timesheet::Base.new.build
    @contacts = Moneybird.new(session[:moneybird_access_token]['access_token']).contacts if authenticated_with_moneybird?
  end
end
