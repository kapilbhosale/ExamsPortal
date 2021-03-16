class PopulateOrgIdInProgressReport < ActiveRecord::Migration[5.2]
  def change
    ProgressReport.connection.schema_cache.clear!
    ProgressReport.reset_column_information
    Org.all.each do |org|
      Student.where(org_id: org.id).each_slice(1000) do |students|
        student_ids = students.select(&:id)
        ProgressReport.where(student_id: student_ids).update_all(org_id: org.id)
      end
    end
  end
end
