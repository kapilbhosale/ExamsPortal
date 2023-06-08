class AddColumnIdCardToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :id_card, :jsonb, default: []
  end
end
