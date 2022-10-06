class Timesheet::Base
  def self.projects
    harvest_projects = Harvest.new.projects(updated_since: (Time.zone.now - 1.year).iso8601)

    return if harvest_projects['projects'].empty?

    harvest_projects['projects'].map do |harvest_project|
      ::Project.find_or_create_by(harvest_project_id: harvest_project['id']) do |project|
        project.harvest_project_name = harvest_project['name']
      end

      build_project(harvest_project)
    end
  end

  def self.project(id)
    harvest_project = Harvest.new.project(id)

    build_project(harvest_project)
  end

  def self.build_project(params)
    Timesheet::Project.new(
      id: params['id'],
      name: params['name'],
      client: params['client'],
      starts_on: params['starts_on'],
      ends_on: params['ends_on']
    )
  end
end
