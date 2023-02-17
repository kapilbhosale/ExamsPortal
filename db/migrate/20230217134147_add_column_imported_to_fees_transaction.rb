class AddColumnImportedToFeesTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :fees_transactions, :imported, :boolean, default: false
  end
end
