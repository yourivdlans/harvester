class SalesInvoice < ApplicationRecord
  belongs_to :project

  scope :newest_first, -> { order(created_at: :desc) }
end
