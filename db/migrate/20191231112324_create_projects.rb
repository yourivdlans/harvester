class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :harvest_project_id
      t.string :harvest_project_name
      t.string :moneybird_sales_invoice_id

      t.timestamps
    end
  end
end
