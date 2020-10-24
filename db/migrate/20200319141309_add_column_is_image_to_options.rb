class AddColumnIsImageToOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :options, :is_image, :boolean, default: false
  end
end
