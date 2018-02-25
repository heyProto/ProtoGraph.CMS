class AddCreatedByUpdatedBy < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :created_by, :integer
    add_column :activities, :updated_by, :integer
    add_column :audio_variations, :account_id, :integer
    add_column :authentications, :created_by, :integer
    add_column :authentications, :updated_by, :integer
    add_column :authentications, :account_id, :integer
    add_column :image_variations, :account_id, :integer
    add_column :page_streams, :account_id, :integer
    add_column :page_streams, :site_id, :integer
    add_column :page_streams, :folder_id, :integer
    add_column :page_todos, :account_id, :integer
    add_column :page_todos, :site_id, :integer
    add_column :page_todos, :folder_id, :integer
    add_column :ref_categories, :account_id, :integer
    add_column :sites, :created_by, :integer
    add_column :sites, :updated_by, :integer
    add_column :site_vertical_navigations, :account_id, :integer
    add_column :template_data, :created_by, :integer
    add_column :template_data, :updated_by, :integer
    add_column :template_pages, :account_id, :integer
  end
end
