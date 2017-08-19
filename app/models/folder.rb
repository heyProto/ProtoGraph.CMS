# == Schema Information
#
# Table name: folders
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  slug       :string(255)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Folder < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    extend FriendlyId
    friendly_id :name, use: :slugged

    after_validation :move_friendly_id_error_to_name

    #ASSOCIATIONS
    belongs_to :account
    #ACCESSORS
    #VALIDATIONS
    validates :name, uniqueness: {scope: [:account], message: "Folder name is already used"}
    has_many :view_casts


    #CALLBACKS

    def move_friendly_id_error_to_name
        errors.add :name, *errors.delete(:friendly_id) if errors[:friendly_id].present?
    end
    #SCOPE
    #OTHER
    #PRIVATE
    private

end
