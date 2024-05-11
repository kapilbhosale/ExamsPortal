class CreateOmrTests < ActiveRecord::Migration[5.2]
  def change
    create_table :omr_tests do |t|
      t.references :org, foreign_key: true
      t.string    :test_name, null: false
      t.string    :description
      t.integer   :no_of_questions, default: 0
      t.integer   :total_marks, default: 0
      t.datetime  :test_date
      t.jsonb     :answer_key, default: {}
      t.integer   :parent_id
      t.string    :db_modified_date
      t.boolean   :is_booklet, default: false
      t.boolean   :is_combine, default: false
      t.string    :branch
      t.jsonb     :data, default: {}
      t.timestamps
    end
  end
end
