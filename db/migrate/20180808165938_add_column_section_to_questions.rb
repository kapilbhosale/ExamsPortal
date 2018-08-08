class AddColumnSectionToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :section_id, :integer, default: 1
  end
end
