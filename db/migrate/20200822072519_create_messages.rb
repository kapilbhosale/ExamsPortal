class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.bigint  :sender_id
      t.string  :sender_type
      t.string  :sender_name
      t.text    :message
      t.bigint  :messageable_id
      t.string  :messageable_type
      t.timestamps
    end

    add_index :messages, [:messageable_type, :messageable_id]
  end
end
