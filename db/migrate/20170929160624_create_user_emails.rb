class CreateUserEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :user_emails do |t|
      t.references :user, foreign_key: true
      t.string :email
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
