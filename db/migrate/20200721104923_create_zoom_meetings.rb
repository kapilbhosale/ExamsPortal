class CreateZoomMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :zoom_meetings do |t|
      t.string    :zoom_meeting_id
      t.string    :password
      t.datetime  :datetime_of_meeting
      t.string    :subject
      t.string    :teacher_name
      t.references :org
      t.timestamps
    end
  end
end
