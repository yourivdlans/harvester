class Timesheet::TimeEntry
  include ActiveModel::Model

  attr_accessor :id, :hours, :notes
end