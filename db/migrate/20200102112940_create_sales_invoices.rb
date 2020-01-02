class CreateSalesInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_invoices do |t|
      t.references :project, foreign_key: true
      t.string :moneybird_sales_invoice_id

      t.timestamps
    end
  end
end
