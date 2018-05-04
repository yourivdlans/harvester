class Timesheet::Task
  include ActiveModel::Model

  attr_accessor :id, :name, :hours, :amount

  def initialize(*args)
    super(*args)

    @amount = 0
  end

  def add_hours(hours)
    @hours += hours

    self
  end

  def hours
    @hours
  end
end
