class AddColumnTpStreamsIdToVideoLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :video_lectures, :tp_streams_id, :string
    add_column :video_lectures, :tp_streams_data, :jsonb, default: {}
  end
end
