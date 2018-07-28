class AddDeviseColumnsToStudent < ActiveRecord::Migration[5.2]
  def change
    ## Database authenticatable
    add_column :students, :email, :string, null: false, default: ""
    add_column :students, :encrypted_password, :string, null: false, default: ""

    ## Recoverable
    add_column :students, :reset_password_token, :string
    add_column :students, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :students, :remember_created_at, :datetime

    ## Trackable
    add_column :students, :sign_in_count, :integer, default: 0, null: false
    add_column :students, :current_sign_in_at, :datetime
    add_column :students, :last_sign_in_at, :datetime
    add_column :students, :current_sign_in_ip, :inet
    add_column :students, :last_sign_in_ip, :inet

    ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

    # add_index :admins, :confirmation_token,   unique: true
    # add_index :admins, :unlock_token,         unique: true
  end
end
