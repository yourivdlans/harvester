class Timesheet::Base
  def initialize
    @projects = []
  end

  def build
    entries = Harvest.new.entries

    return if entries['time_entries'].length == 0

    entries['time_entries'].each do |entry|
      project = new_or_existing_project(id: entry['project']['id'], name: entry['project']['name'])
      project.add_task(id: entry['task']['id'], name: entry['task']['name'], hours: entry['hours'])
      project.add_time_entry(id: entry['id'], hours: entry['hours'], notes: entry['notes'])
    end

    @projects
  end

  def new_or_existing_project(params)
    return project(params[:id]) if project(params[:id])

    new_project = Timesheet::Project.new(id: params[:id], name: params[:name])

    @projects.push(new_project)

    new_project
  end

  def project(id)
    @projects.detect { |i| i.id == id }
  end
end
