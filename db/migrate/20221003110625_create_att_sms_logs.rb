class CreateAttSmsLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :att_sms_logs do |t|
      t.references :batch
      t.integer :present_count
      t.integer :absent_count
      t.timestamps
    end
  end
end
