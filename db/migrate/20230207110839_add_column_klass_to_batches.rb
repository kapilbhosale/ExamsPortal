class AddColumnKlassToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :klass, :string
  end
end
