class Project < ApplicationRecord
  has_many :sales_invoices, dependent: :destroy
end
