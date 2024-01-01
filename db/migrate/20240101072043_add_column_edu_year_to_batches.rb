class AddColumnEduYearToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :edu_year, :string, default: "2024-25"
  end
end
