class AddCols394003ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :website, :text
    add_column :users, :facebook, :text
    add_column :users, :twitter, :text
    add_column :users, :phone, :string
    add_column :users, :linkedin, :text
    add_column :permission_invites, :name, :string
    add_column :permission_invites, :create_user, :boolean
    add_column :permission_invites, :do_not_email_user, :boolean
    add_column :permissions, :bio, :text
    add_column :permissions, :meta_description, :text
    add_column :permissions, :name, :string
  end
end
