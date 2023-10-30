class CreateBatchHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_holidays do |t|
      t.references  :org
      t.references  :batch
      t.date        :holiday_date
      t.string      :comment
      t.timestamps
    end
  end
end
