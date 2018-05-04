class Timesheet::Base
  def build
    projects = Harvest.new.projects(updated_since: (Time.zone.now - 1.year).iso8601)
    # projects = Harvest.new.projects(per_page: 3)

    return if projects['projects'].length == 0

    projects['projects'].map do |project|
      Timesheet::Project.new(id: project['id'], name: project['name'], client: project['client']).tap do |prj|
        prj.fetch_time_entries
      end
    end
  end
end
