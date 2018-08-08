class AddColumnWeightageToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :concepts, :weightage, :integer, default: 0
  end
end
