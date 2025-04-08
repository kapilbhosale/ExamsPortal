class CreateReportPrintStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :report_print_statuses do |t|
      t.references :admin, foreign_key: true
      t.string :report_type
      t.string :branch
      t.string :status
      t.timestamps
    end
  end
end
