class AddColumn123toUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :can_publish_link_sources, :boolean, default: false
    User.where(email: ['ab@pykih.com', "ritvvij.parrikh@pykih.com", "aashutosh.bhatt@pykih.com"]).update_all(can_publish_link_sources: true)
  end
end
