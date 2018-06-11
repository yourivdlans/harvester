class Timesheet::Project
  include ActiveModel::Model

  attr_accessor :id, :name
  attr_writer :starts_on, :ends_on
  attr_reader :client, :tasks, :time_entries

  def initialize(attributes = {})
    super
    @tasks = []
    @time_entries = []
  end

  def fetch_time_entries
    time_entries = Harvest.new.time_entries(project_id: id)

    return if time_entries['time_entries'].empty?

    time_entries['time_entries'].each do |time_entry|
      task = add_task(id: time_entry['task']['id'], name: time_entry['task']['name'], hours: time_entry['hours'])
      time_entry = add_time_entry(id: time_entry['id'], hours: time_entry['hours'], notes: time_entry['notes'], billable_rate: time_entry['billable_rate'])

      task.amount += time_entry.amount
    end
  end

  def client=(params)
    @client = Timesheet::Client.new(id: params['id'], name: params['name'])
  end

  def add_task(params)
    if (task = task(params[:id]))
      return task.add_hours(params[:hours])
    end

    new_task = Timesheet::Task.new(params)

    @tasks.push(new_task)

    new_task
  end

  def add_time_entry(params)
    return if time_entry(params[:id])

    new_time_entry = Timesheet::TimeEntry.new(params)

    @time_entries.push(new_time_entry)

    new_time_entry
  end

  def task(id)
    @tasks.detect { |i| i.id == id }
  end

  def time_entry(id)
    @time_entries.detect { |i| i.id == id }
  end

  def hours
    @time_entries.inject(0) { |acc, elem| acc + elem.hours }
  end

  def amount
    @time_entries.map(&:amount).sum
  end

  def starts_on
    return if @starts_on.blank?

    Date.parse(@starts_on)
  end

  def ends_on
    return if @ends_on.blank?

    Date.parse(@ends_on)
  end

  def period
    return if starts_on.blank? || ends_on.blank?

    "#{starts_on.strftime('%Y%m%d')}..#{ends_on.strftime('%Y%m%d')}"
  end

  def paid?(paid_projects)
    paid_projects.any? { |prj| prj[:description] == name && prj[:period] == period }
  end
end
