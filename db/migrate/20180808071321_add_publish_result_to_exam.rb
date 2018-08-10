class AddPublishResultToExam < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :exams, :publish_result
      add_column :exams, :publish_result, :boolean, null: false, default: false
    end
  end
end
