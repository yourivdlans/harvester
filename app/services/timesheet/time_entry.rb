class Timesheet::TimeEntry
  include ActiveModel::Model

  attr_accessor :id, :hours, :notes, :billable_rate

  def amount
    return 0 if billable_rate.blank?

    billable_rate * hours
  end
end
