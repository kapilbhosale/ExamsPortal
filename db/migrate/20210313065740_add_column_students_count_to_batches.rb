class AddColumnStudentsCountToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :students_count, :integer, default: 0
  end
end
