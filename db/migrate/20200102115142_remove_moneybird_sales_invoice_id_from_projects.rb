class RemoveMoneybirdSalesInvoiceIdFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :moneybird_sales_invoice_id, :string
  end
end
