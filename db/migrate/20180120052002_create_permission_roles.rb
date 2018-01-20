class CreatePermissionRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :permission_roles do |t|
      t.integer :created_by
      t.integer :updated_by
      t.string :name
      t.string :slug
      t.boolean :can_change_account_settings
      t.boolean :can_add_image_bank
      t.boolean :can_see_all_image_bank
      t.boolean :can_add_site
      t.boolean :can_change_site_settings
      t.boolean :can_add_site_people
      t.boolean :can_add_site_categories
      t.boolean :can_disable_site_categories
      t.boolean :can_add_site_tags
      t.boolean :can_remove_site_tags
      t.boolean :can_add_folders
      t.boolean :can_see_all_folders
      t.boolean :can_add_folder_people
      t.boolean :can_add_view_casts
      t.boolean :can_see_all_view_casts
      t.boolean :can_delete_view_casts
      t.boolean :can_add_streams
      t.boolean :can_delete_streams
      t.boolean :can_see_all_streams
      t.boolean :can_add_pages
      t.boolean :can_edit_pages
      t.boolean :can_see_all_pages

      t.timestamps
    end


    user_id = User.where(email: 'ab@pykih.com').first.id
    PermissionRole.create({created_by: user_id,
      updated_by: user_id ,
      name: "Owner",
      slug: "owner",
      can_change_account_settings: 1,
      can_add_image_bank: 1,
      can_see_all_image_bank: 1,
      can_add_site: 1,
      can_change_site_settings: 1,
      can_add_site_people: 1,
      can_add_site_categories: 1,
      can_disable_site_categories: 1,
      can_add_site_tags: 1,
      can_remove_site_tags: 1,
      can_add_folders: 1,
      can_see_all_folders: 1,
      can_add_folder_people: 1,
      can_add_view_casts: 1,
      can_see_all_view_casts: 1,
      can_delete_view_casts: 1,
      can_add_streams: 1,
      can_delete_streams: 1,
      can_see_all_streams: 1,
      can_add_pages: 1,
      can_edit_pages: 1,
      can_see_all_pages: 1})


    PermissionRole.create({created_by: user_id,
      updated_by: user_id,
      name: "Editor",
      slug: "editor",
      can_change_account_settings: 0,
      can_add_image_bank: 1,
      can_see_all_image_bank: 1,
      can_add_site: 0,
      can_change_site_settings: 1,
      can_add_site_people: 1,
      can_add_site_categories: 1,
      can_disable_site_categories: 1,
      can_add_site_tags: 1,
      can_remove_site_tags: 1,
      can_add_folders: 1,
      can_see_all_folders: 1,
      can_add_folder_people: 1,
      can_add_view_casts: 1,
      can_see_all_view_casts: 1,
      can_delete_view_casts: 1,
      can_add_streams: 1,
      can_delete_streams: 1,
      can_see_all_streams: 1,
      can_add_pages: 1,
      can_edit_pages:  1,
      can_see_all_pages: 1})

    PermissionRole.create({created_by: user_id,
      updated_by: user_id,
      name: "Writer",
      slug: "writer",
      can_change_account_settings: 0,
      can_add_image_bank: 1,
      can_see_all_image_bank: 1,
      can_add_site: 0,
      can_change_site_settings: 0,
      can_add_site_people: 0,
      can_add_site_categories: 1,
      can_disable_site_categories: 0,
      can_add_site_tags: 1,
      can_remove_site_tags: 0,
      can_add_folders: 1,
      can_see_all_folders: 0,
      can_add_folder_people: 0,
      can_add_view_casts: 1,
      can_see_all_view_casts: 1,
      can_delete_view_casts: 0,
      can_add_streams: 0,
      can_delete_streams: 0,
      can_see_all_streams: 0,
      can_add_pages: 1,
      can_edit_pages: 1,
      can_see_all_pages: 1})

    PermissionRole.create({created_by: user_id,
      updated_by: user_id,
      name: "Contributor",
      slug: "contributor",
      can_change_account_settings: 0,
      can_add_image_bank: 0,
      can_see_all_image_bank: 0,
      can_add_site:  0,
      can_change_site_settings: 0,
      can_add_site_people: 0,
      can_add_site_categories: 0,
      can_disable_site_categories: 0,
      can_add_site_tags: 0,
      can_remove_site_tags: 0,
      can_add_folders: 1,
      can_see_all_folders: 0,
      can_add_folder_people: 0,
      can_add_view_casts: 1,
      can_see_all_view_casts: 0,
      can_delete_view_casts: 0,
      can_add_streams: 0,
      can_delete_streams: 0,
      can_see_all_streams: 0,
      can_add_pages: 1,
      can_edit_pages: 1,
      can_see_all_pages: 0})

    Permission.where(ref_role_slug: 'doer').update_all(ref_role_slug: "writer")


  end
end
