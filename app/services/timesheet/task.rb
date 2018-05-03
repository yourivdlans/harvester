class Timesheet::Task
  include ActiveModel::Model

  attr_accessor :id, :name, :hours

  def add_hours(hours)
    @hours += hours

    self
  end

  def hours
    @hours.round(2)
  end
end
