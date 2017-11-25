class AddIsPrimaryEmailToUserEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :user_emails, :is_primary_email, :boolean
  end
end
