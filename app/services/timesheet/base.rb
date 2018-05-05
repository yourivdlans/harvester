class Timesheet::Base
  def build
    projects = Harvest.new.projects(updated_since: (Time.zone.now - 1.year).iso8601)

    return if projects['projects'].length == 0

    projects['projects'].map do |project|
      self.class.new_project(project)
    end
  end

  def self.new_project(params)
    Timesheet::Project.new(
      id: params['id'],
      name: params['name'],
      client: params['client'],
      starts_on: params['starts_on'],
      ends_on: params['ends_on']
    ).tap do |prj|
      prj.fetch_time_entries
    end
  end
end
