# == Schema Information
#
# Table name: ref_tags
#
#  id          :integer          not null, primary key
#  site_id     :integer
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  stream_url  :text(65535)
#  stream_id   :integer
#  is_disabled :boolean
#  created_by  :boolean
#  updated_by  :boolean
#  count       :integer
#

class RefTag < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :site
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"
    #ACCESSORS
    attr_accessor :genre
    #VALIDATIONS
    validates :name, presence: true, uniqueness: {scope: :site}, length: { in: 3..15 }
    #CALLBACKS
    before_update :before_update_set
    #SCOPE
    #OTHER
    #PRIVATE
    private

    def before_update_set
        self.is_disabled = true if self.count > 0
    end

end
