class AddColumnOmrToProgressReport < ActiveRecord::Migration[5.2]
  def change
    add_column :progress_reports, :omr, :boolean, default: false
  end
end
