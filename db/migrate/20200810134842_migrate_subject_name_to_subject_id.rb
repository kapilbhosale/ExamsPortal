class MigrateSubjectNameToSubjectId < ActiveRecord::Migration[5.2]
  def change
    VideoLecture.connection.schema_cache.clear!
    VideoLecture.reset_column_information

    VideoLecture.all.each do |video_lectrue|
      subject = Subject.find_or_create_by(
        name: video_lectrue.subject_name,
        org_id: video_lectrue.org_id
      )
      video_lectrue.subject_id = subject.id
      video_lectrue.save
    end

    # delete subjects with no videos
    Subject.all.each do |subject|
      subject.destroy if subject.video_lectures.blank?
    end
  end
end
