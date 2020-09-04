class AddColumnHiddenToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :hidden, :boolean, default: false
  end
end
