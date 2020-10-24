class AddColumnSubjectIdToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :subject_id, :integer
  end
end
