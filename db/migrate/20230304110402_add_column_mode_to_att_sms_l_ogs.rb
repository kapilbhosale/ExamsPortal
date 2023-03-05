class AddColumnModeToAttSmsLOgs < ActiveRecord::Migration[5.2]
  def change
    add_column :att_sms_logs, :mode, :string
  end
end
