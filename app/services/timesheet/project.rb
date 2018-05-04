class Timesheet::Project
  include ActiveModel::Model

  attr_accessor :id, :name
  attr_reader :client, :tasks, :time_entries

  def initialize(attributes={})
    super
    @tasks = []
    @time_entries = []
  end

  def fetch_time_entries
    time_entries = Harvest.new.time_entries(project_id: id)

    return if time_entries['time_entries'].length == 0

    time_entries['time_entries'].each do |time_entry|
      add_task(id: time_entry['task']['id'], name: time_entry['task']['name'], hours: time_entry['hours'])
      add_time_entry(id: time_entry['id'], hours: time_entry['hours'], notes: time_entry['notes'], billable_rate: time_entry['billable_rate'])
    end
  end

  def client=(params)
    @client = Timesheet::Client.new(id: params['id'], name: params['name'])
  end

  def add_task(params)
    if task = task(params[:id])
      return task.add_hours(params[:hours])
    end

    @tasks.push(Timesheet::Task.new(params))
  end

  def add_time_entry(params)
    return if time_entry(params[:id])

    @time_entries.push(Timesheet::TimeEntry.new(params))
  end

  def task(id)
    @tasks.detect { |i| i.id == id }
  end

  def time_entry(id)
    @time_entries.detect { |i| i.id == id }
  end

  def hours
    @time_entries.inject(0) { |sum, i| sum + i.hours }
  end

  def amount
    @time_entries.map(&:amount).sum
  end
end
