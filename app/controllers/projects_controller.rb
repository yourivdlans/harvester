class ProjectsController < ApplicationController
  layout false

  def index
    @projects = Timesheet::Base.new.build

    @project_states = authenticated_with_moneybird? ? Moneybird.new(session[:moneybird_access_token]).project_states : []
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
end
