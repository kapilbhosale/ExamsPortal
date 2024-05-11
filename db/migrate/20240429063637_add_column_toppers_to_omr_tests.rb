class AddColumnToppersToOmrTests < ActiveRecord::Migration[5.2]
  def change
    add_column :omr_tests, :toppers, :jsonb, default: {}
  end
end
