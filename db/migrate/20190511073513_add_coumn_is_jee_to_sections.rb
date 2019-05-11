class AddCoumnIsJeeToSections < ActiveRecord::Migration[5.2]
  def change
    add_column :sections, :is_jee, :boolean, default: false
    add_column :sections, :description, :text
  end
end
