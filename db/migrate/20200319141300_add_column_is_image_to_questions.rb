class AddColumnIsImageToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :is_image, :boolean, default: false
  end
end
