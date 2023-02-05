class AddColumnClassToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :klass, :string
  end
end
