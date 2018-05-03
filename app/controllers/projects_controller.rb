class ProjectsController < ApplicationController
  def index
    @projects = Timesheet::Base.new.build
  end
end
