class AddColumnGenreIdToStudyPdfs < ActiveRecord::Migration[5.2]
  def change
    add_reference :study_pdfs, :genre
    add_column :genres, :study_pdfs_count, :integer, default: 0
  end
end
