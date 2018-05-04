class Timesheet::Base
  def build
    projects = Harvest.new.projects(per_page: 10)

    return if projects['projects'].length == 0

    projects['projects'].map do |project|
      Timesheet::Project.new(id: project['id'], name: project['name'], client: project['client']).tap do |prj|
        prj.fetch_time_entries
      end
    end
  end
end
