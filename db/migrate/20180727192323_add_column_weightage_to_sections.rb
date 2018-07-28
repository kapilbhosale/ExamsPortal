class AddColumnWeightageToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :weightage, :integer, default: 0
  end
end
