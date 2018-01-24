# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  name        :string(255)
#  slug        :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_trash    :boolean          default(FALSE)
#  is_archived :boolean          default(FALSE)
#  site_id     :integer
#  is_open     :boolean
#

class Folder < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    include Associable
    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged

    after_validation :move_friendly_id_error_to_name

    #ASSOCIATIONS
    belongs_to :account
    belongs_to :site
    has_many :streams, dependent: :destroy
    has_many :uploads, dependent: :destroy
    has_many :activities
    has_many :uploads, dependent: :destroy
    has_many :pages
    has_many :permissions, ->{where(status: "Active", permissible_type: 'Folder')}, foreign_key: "permissible_id", dependent: :destroy
    has_many :users, through: :permissions
    #ACCESSORS
    attr_accessor :is_system_generated, :collaborator_lists
    #VALIDATIONS
    validates :name, exclusion: {in: ["Recycle Bin"], message: "Is a reserved name."}, unless: :is_system_generated
    validates :name, uniqueness: {scope: [:account], message: "Folder name is already used."}
    has_many :view_casts, dependent: :destroy


    #CALLBACKS
    after_save :after_save_set

    def move_friendly_id_error_to_name
        errors.add :name, *errors.delete(:friendly_id) if errors[:friendly_id].present?
    end
    #SCOPE
    #OTHER
    def should_generate_new_friendly_id?
        name_changed?
    end
    #PRIVATE
    private

    def after_save_set
        if self.collaborator_lists.present?
            self.collaborator_lists = self.collaborator_lists.reject(&:empty?)
            prev_collaborator_ids = self.permissions.pluck(:user_id)
            self.collaborator_lists.each do |c|
                user = User.find(c)
                a = user.create_permission("Folder", self.id, "contributor")
            end
            self.permissions.where(permissible_id: (prev_collaborator_ids - self.collaborator_lists.map{|a| a.to_i})).update_all(status: 'Deactivated')
        end
    end

end
