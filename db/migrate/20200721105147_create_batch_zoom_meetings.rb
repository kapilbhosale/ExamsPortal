class CreateBatchZoomMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_zoom_meetings do |t|
      t.references :zoom_meeting
      t.references :batch
      t.timestamps
    end
  end
end
