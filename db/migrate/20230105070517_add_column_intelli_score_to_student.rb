class AddColumnIntelliScoreToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :intel_score, :integer
  end
end
