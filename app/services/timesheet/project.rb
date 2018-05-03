class Timesheet::Project
  include ActiveModel::Model

  attr_accessor :id, :name, :tasks, :time_entries

  def initialize(attributes={})
    super
    @tasks = []
    @time_entries = []
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

  def uninvoiced_hours
    @time_entries.inject(0) { |sum, i| sum + i.hours }.round(2)
  end
end
