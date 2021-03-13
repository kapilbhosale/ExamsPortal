class PopulateCouneterCacheStudents < ActiveRecord::Migration[5.2]
  def change
    Batch.find_each do |batch|
      batch.re_count_students
    end
  end
end
