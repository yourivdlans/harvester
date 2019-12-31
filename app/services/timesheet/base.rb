class Timesheet::Base
  def build
    projects = Harvest.new.projects(updated_since: (Time.zone.now - 1.year).iso8601)

    return if projects['projects'].empty?

    projects['projects'].map do |harvest_project|
      ::Project.find_or_create_by(harvest_project_id: harvest_project['id']) do |project|
        project.harvest_project_name = harvest_project['name']
      end

      self.class.new_project(harvest_project)
    end
  end

  def self.new_project(params)
    Timesheet::Project.new(
      id: params['id'],
      name: params['name'],
      client: params['client'],
      starts_on: params['starts_on'],
      ends_on: params['ends_on']
    )
  end
end
