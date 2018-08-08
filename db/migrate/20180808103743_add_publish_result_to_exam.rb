class AddPublishResultToExam < ActiveRecord::Migration[5.2]
  def change
    add_column :exams, :publish_result, :boolean, null: false, default: false
  end
end
