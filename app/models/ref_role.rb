# == Schema Information
#
# Table name: ref_roles
#
#  id                          :integer          not null
#  name                        :string(255)
#  slug                        :string(255)      primary key
#  can_account_settings        :boolean
#  can_template_design_do      :boolean
#  can_template_design_publish :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class RefRole < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    self.primary_key = "slug"

    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged

    #ASSOCIATIONS
    #ACCESSORS
    #VALIDATIONS
    #CALLBACKS
    #SCOPE
    #OTHER

    def self.seed
        RefRole.destroy_all
        RefRole.create(name: "Owner", slug: "owner",
                        can_account_settings: true,
                        can_template_design_do: true,
                        can_template_design_publish: true)

        RefRole.create(name: "Editor", slug: "editor",
                        can_account_settings: true,
                        can_template_design_do: false,
                        can_template_design_publish: false)

        RefRole.create(name: "Developer", slug: "developer",
                        can_account_settings: false,
                        can_template_design_do: true,
                        can_template_design_publish: false)

        RefRole.create(name: "Writer", slug: "writer",
                        can_account_settings: false,
                        can_template_design_do: false,
                        can_template_design_publish: false)
    end

    #PRIVATE
    private

end
