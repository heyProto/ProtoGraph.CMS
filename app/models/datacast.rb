# == Schema Information
#
# Table name: datacasts
#
#  id                    :integer          not null, primary key
#  slug                  :string(255)
#  template_datum_id     :integer
#  external_identifier   :string(255)
#  status                :string(255)
#  data_timestamp        :datetime
#  last_updated_at       :datetime
#  last_data_hash        :string(255)
#  count_publish         :integer
#  count_duplicate_calls :integer
#  count_errors          :integer
#  input_source          :string(255)
#  error_messages        :text(65535)
#  data                  :text(65535)
#  created_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Datacast < ApplicationRecord

    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #ASSOCIATIONS
    belongs_to :template_datum
    belongs_to :creator, class_name: "User", foreign_key: "created_by"
    has_many :datacast_accounts
    has_many :accounts, through: :datacast_accounts

    #ACCESSORS
    #VALIDATIONS
    validates :account_id, presence: true

    #CALLBACKS
    #SCOPE
    #OTHER
    #Todo AMIT - Add taggable model for searching.
    #PRIVATE
    private

end
