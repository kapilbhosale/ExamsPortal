class CreateRollNumberSuggestors < ActiveRecord::Migration[5.2]
  def change
    create_table :roll_number_suggestors do |t|
      t.string  :batch_name
      t.string  :criteria
      t.integer :initial_suggested
      t.integer :last_suggested
      t.timestamps
    end
  end
end
