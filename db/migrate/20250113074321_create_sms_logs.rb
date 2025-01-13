class CreateSmsLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :sms_logs do |t|
      t.string :mobile
      t.string :message
      t.references :org, index: true
      t.references :student, index: true
      t.timestamps
    end

    add_index :sms_logs, :mobile
  end
end