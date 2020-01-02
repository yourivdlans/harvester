class MigrateSalesInvoices < ActiveRecord::Migration[5.2]
  def up
    Project.all.each do |project|
      project.sales_invoices.create!(moneybird_sales_invoice_id: project.moneybird_sales_invoice_id)
    end
  end
end
