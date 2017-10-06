# == Schema Information
#
# Table name: ref_codes
#
#  id         :integer          not null, primary key
#  account_id :integer
#  key        :string(255)
#  val        :string(255)
#  is_default :boolean
#  sort_order :integer
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RefCode < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :account
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    belongs_to :updator, class_name: "User", foreign_key: "updated_by"

    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true
    validates :val, presence: true
    validates :created_by, presence: true
    validates :updated_by, presence: true

    #CALLBACKS
    before_create :before_create_set

    #SCOPE
    #OTHER

    def self.seed(aid, uid)
        ["Opinion", "Analysis", "Reportage", "Wire", "News", "Breaking", "Exclusive"].each do |a|
            RefCode.create(account_id: aid, val: a, created_by: uid, updated_by: uid)
        end
    end

    #PRIVATE
    private

    def before_create_set
        self.key = "article.genre"
        siblings_sorted = self.account.ref_codes.where(key: self.key).order("sort_order DESC").first
        if siblings_sorted.present?
            siblings_default = self.account.ref_codes.where(key: self.key, is_default: true).first
            self.is_default = siblings_default.present? ? false : true
            self.sort_order = siblings_sorted.sort_order + 1
        else
            self.is_default = true
            self.sort_order = 1
        end
        true
    end

end
