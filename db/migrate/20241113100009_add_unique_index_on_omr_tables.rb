class AddUniqueIndexOnOmrTables < ActiveRecord::Migration[5.2]
  def change
    unless index_exists?(:omr_students, [:roll_number, :parent_contact], name: 'index_omr_students_on_roll_number_and_parent_contact')
      add_index :omr_students, [:roll_number, :parent_contact], unique: true, name: 'index_omr_students_on_roll_number_and_parent_contact'
    end

    unless index_exists?(:omr_batches, [:name, :branch], name: 'index_omr_batches_on_name_and_branch')
      add_index :omr_batches, [:name, :branch], unique: true, name: 'index_omr_batches_on_name_and_branch'
    end

    unless index_exists?(:omr_student_batches, [:omr_student_id, :omr_batch_id], name: 'index_omr_student_batches_on_omr_student_id_and_omr_batch_id')
      add_index :omr_student_batches, [:omr_student_id, :omr_batch_id], unique: true, name: 'index_omr_student_batches_on_omr_student_id_and_omr_batch_id'
    end

    unless index_exists?(:omr_batch_tests, [:omr_test_id, :omr_batch_id], name: 'index_omr_batch_tests_on_omr_test_id_and_omr_batch_id')
      add_index :omr_batch_tests, [:omr_test_id, :omr_batch_id], unique: true, name: 'index_omr_batch_tests_on_omr_test_id_and_omr_batch_id'
    end

    unless index_exists?(:omr_student_tests, [:omr_student_id, :omr_test_id], name: 'index_omr_student_tests_on_omr_student_id_and_omr_test_id')
      add_index :omr_student_tests, [:omr_student_id, :omr_test_id], unique: true, name: 'index_omr_student_tests_on_omr_student_id_and_omr_test_id'
    end
  end
end
