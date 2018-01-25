# == Schema Information
#
# Table name: permission_roles
#
#  id                          :integer          not null, primary key
#  created_by                  :integer
#  updated_by                  :integer
#  name                        :string(255)
#  slug                        :string(255)
#  can_change_account_settings :boolean
#  can_add_image_bank          :boolean
#  can_see_all_image_bank      :boolean
#  can_add_site                :boolean
#  can_change_site_settings    :boolean
#  can_add_site_people         :boolean
#  can_add_site_categories     :boolean
#  can_disable_site_categories :boolean
#  can_add_site_tags           :boolean
#  can_remove_site_tags        :boolean
#  can_add_folders             :boolean
#  can_see_all_folders         :boolean
#  can_add_folder_people       :boolean
#  can_add_view_casts          :boolean
#  can_see_all_view_casts      :boolean
#  can_delete_view_casts       :boolean
#  can_add_streams             :boolean
#  can_delete_streams          :boolean
#  can_see_all_streams         :boolean
#  can_add_pages               :boolean
#  can_edit_pages              :boolean
#  can_see_all_pages           :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class PermissionRole < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER
    #PRIVATE

end
